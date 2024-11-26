<script>
	import '@appwrite.io/pink';
	import '@appwrite.io/pink-icons';

	import { t } from 'svelte-i18n';
</script>

<slot />

<div style="display: none;" id="sitemap-links">
	<a href="/">{$t('general.home')}</a>
	<a href="/sign-up">{$t('general.signup')}</a>
	<a href="/sms-login">{$t('general.phone_login')}</a>
	<a href="/email-login">{$t('general.email_login')}</a>
	<a href="/forgot-password">{$t('general.password_recovery')}</a>
</div>
