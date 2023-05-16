
{{/* Make sure all variables are set properly */}}
{{- include "common.values.setup" . }}

{{- define "repman.repman.config.services" -}}
parameters:
  aws_s3_region: '%env(STORAGE_AWS_REGION)%'
  aws_s3_default_endpoint: 'https://s3.%aws_s3_region%.amazonaws.com'
services:
  Aws\S3\S3Client:
    lazy: true
    arguments:
    - version: 'latest'
      region: '%aws_s3_region%'
      endpoint: '%env(default:aws_s3_default_endpoint:STORAGE_AWS_ENDPOINT)%'
      use_path_style_endpoint: '%env(bool:STORAGE_AWS_PATH_STYLE_ENDPOINT)%'
      credentials:
        key: '%env(STORAGE_AWS_KEY)%'
        secret: '%env(STORAGE_AWS_SECRET)%'
  {{- if not .Values.redis.enabled }}
  Symfony\Component\HttpFoundation\Session\Storage\Handler\PdoSessionHandler:
    arguments:
      - 'postgresql://%env(DATABASE_USER)%:%env(DATABASE_PASSWORD)%@%env(DATABASE_HOSTNAME)%:5432/%env(DATABASE_DATABASE)%?serverVersion=%env(DATABASE_VERSION)%&charset=utf8'
framework:
  session:
    handler_id: Symfony\Component\HttpFoundation\Session\Storage\Handler\PdoSessionHandler
  {{- end }}
doctrine:
  dbal:
    url: 'postgresql://%env(DATABASE_USER)%:%env(DATABASE_PASSWORD)%@%env(DATABASE_HOSTNAME)%:5432/%env(DATABASE_DATABASE)%?serverVersion=%env(DATABASE_VERSION)%&charset=utf8'
{{- end -}}


{{- define "repman.repman.migration.session" -}}
<?php
declare(strict_types=1);
namespace Buddy\Repman\Migrations;
use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;
/**
* Auto-generated Migration: Please modify to your needs!
*/
final class Version20210115094614 extends AbstractMigration
{
    public function getDescription() : string
    {
        return 'add sessions to database';
    }
    public function up(Schema $schema) : void
    {
        $this->addSql('CREATE TABLE sessions (sess_id VARCHAR(128) NOT NULL PRIMARY KEY,sess_data BYTEA NOT NULL,sess_lifetime INTEGER NOT NULL, sess_time INTEGER NOT NULL);');
    }
    public function down(Schema $schema) : void
    {
        // this down() migration is auto-generated, please modify it to your needs
    }
}
{{- end -}}

{{- define "repman.repman.config.secrets" -}}
{{- $existingSecret := lookup "v1" "Secret" .Release.Namespace (include "common.names.fullname" .) | default dict -}}
{{- $secret := dig "data" "APP_SECRET" (randAlphaNum 32 | b64enc) $existingSecret }}
APP_SECRET: {{ $secret | b64dec }}
{{- end -}}

{{- define "repman.repman.config.phpConfig" -}}
{{- if .Values.redis.enabled -}}
session.save_handler="redis"
session.save_path=tcp://{{ include "common.names.releasename" . }}-redis:6379
{{- end -}}
{{- range $name, $value := .Values.phpConfig }}
{{ $name }}=
{{- if kindIs "string" $value -}}
  {{- $value | quote -}}
{{- else if or (kindIs "list" $value) (kindIs "map" $value) -}}
  {{- fail "lists are not supported for php config" -}}
{{- else -}}
  {{- $value -}}
{{- end -}}
{{ end }}
{{- end -}}
