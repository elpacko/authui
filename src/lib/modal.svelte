<script lang="ts">
	import { browser } from '$app/environment';
	import { Account, Client, type Models } from 'appwrite';
	import { AppwriteService } from './appwrite';
	import { t } from 'svelte-i18n';
	import ForgotPasswordFinish from './forgot-password-finish.svelte';
	import ForgotPassword from './forgot-password.svelte';
	import MagicUrlFinish from './magic-url-finish.svelte';
	import MagicUrl from './magic-url.svelte';
	import PhoneLogin from './phone-login.svelte';
	import SignIn from './sign-in.svelte';
	import SignUp from './sign-up.svelte';
	import { invalidateAll } from '$app/navigation';

	export let isPreview = false;

	export let darkTheme: boolean = false;
	export let fileId: string = '';
	export let borderRadius: 'xs' | 'm' | 'xl' = 'xs';
	export let brandColor: 'primary' | 'success' | 'information' | 'warning' | 'neutral' | string =
		'primary';
	export let lightContrast = true;
	export let name: string = '';
	export let allowSignUp = true;

	export let successUrl: string = '';
	export let failureUrl: string = '';
	export let provider: string = '';
	export let providerData: string = '';

	export let termsOfService: string = '';
	export let privacyPolicy: string = '';

	export let allowGuest: boolean = false;
	export let allowGoogle: boolean = false;
	export let allowGitHub: boolean = false;
	export let allowTwitter: boolean = false;
	export let allowFacebook: boolean = false;
	export let allowPhone: boolean = false;
	export let allowMagicUrl: boolean = false;
	export let allowEmailOtp: boolean = false;
	export let currentUser: null | Models.User<any>;

	export let action:
		| 'signIn'
		| 'signUp'
		| 'forgotPassword'
		| 'forgotPasswordFinish'
		| 'phoneLogin'
		| 'magicUrl'
		| 'magicUrlFinish' = 'signIn';

	function getClient() {
		if (isPreview) {
			throw new Error('Functionality disabled in preview.');
		}

		if (provider !== 'appwrite') {
			throw new Error('Provider not supported.');
		}

		const { providerEndpoint, providerProject } = JSON.parse(providerData);

		return new Client().setEndpoint(providerEndpoint).setProject(providerProject);
	}

	let isSignOutLoading = false;
	let signOutError = '';
	async function signOut() {
		if (isSignOutLoading) {
			return;
		}

		isSignOutLoading = true;
		signOutError = '';

		try {
			const account = new Account(getClient());
			await account.deleteSession('current');
			await invalidateAll();
		} catch (err: any) {
			signOutError = err.message;
			isSignOutLoading = false;
		}
	}
</script>

<div
	style={`width: 100%; --c-border-radius: ${
		borderRadius === 'xs' ? '4px' : borderRadius === 'm' ? '12px' : '20px'
	}; --c-border-radius-card: ${
		borderRadius === 'xs' ? '16px' : borderRadius === 'm' ? '24px' : '32px'
	}; --c-border-radius-logo: ${
		borderRadius === 'xs' ? '4xp' : borderRadius === 'm' ? '16px' : '32px'
	}; --c-brand-color: ${
		brandColor.startsWith('#') ? brandColor : `hsl(var(--color-${brandColor}-100))`
	}; --c-brand-contrast: ${lightContrast ? '#FFFFFF' : '#000000'};`}
	class="c-modal u-flex u-flex-vertical u-gap-8"
>
	<a href={isPreview ? undefined : failureUrl} class="button is-text" style="padding: 0px;"
		><span class="icon-cheveron-left" aria-hidden="true" /><span class="text">Back to Website</span
		></a
	>

	{#if currentUser === null}
		<section class="card c-border-radius" style="width: 100%;">
			<div class="u-max-width-500 u-width-full-line">
				<div class="u-flex u-main-center">
					<img
						class="c-border-radius-logo"
						src={fileId ? AppwriteService.getLogo(fileId) : '/favicon.png'}
						height="64"
						alt="Logo"
					/>
				</div>

				<h1 class="u-text-center u-margin-block-start-24 heading-level-3 u-margin-block-start-auto">
					{#if action === 'signIn'}
						{$t('general.signin')} {name ? $t('modal.to') : ''}
					{:else if action === 'signUp'}
						{$t('general.signup')}
					{:else if action === 'magicUrl' || action === 'magicUrlFinish'}
						{$t('general.signin_email')}
					{:else if action === 'phoneLogin'}
						{$t('general.signin_sms')}
					{:else if action === 'forgotPassword' || action === 'forgotPasswordFinish'}
						{$t('modal.password_recovery')}
					{/if}
				</h1>
				<div class="u-margin-block-start-24">
					<div class="form common-section" data-hs-cf-bound="true">
						<ul class="form-list">
							{#if action === 'signIn'}
								<SignIn
									{allowSignUp}
									{isPreview}
									{successUrl}
									{failureUrl}
									{getClient}
									{allowGitHub}
									{allowTwitter}
									{allowFacebook}
									{allowGoogle}
									{allowGuest}
									{allowMagicUrl}
									{allowEmailOtp}
									{allowPhone}
								/>
							{:else if action === 'signUp'}
								<SignUp {isPreview} {successUrl} {getClient} />
							{:else if action === 'forgotPassword'}
								<ForgotPassword {allowSignUp} {isPreview} {getClient} />
							{:else if action === 'forgotPasswordFinish'}
								<ForgotPasswordFinish {getClient} />
							{:else if action === 'magicUrl'}
								<MagicUrl {successUrl} {allowMagicUrl} {allowEmailOtp} {isPreview} {getClient} />
							{:else if action === 'magicUrlFinish'}
								<MagicUrlFinish {isPreview} {successUrl} {getClient} />
							{:else if action === 'phoneLogin'}
								<PhoneLogin {isPreview} {successUrl} {getClient} />
							{/if}
						</ul>
					</div>
				</div>
			</div>
		</section>

		<p
			style="color: hsl(var(--color-neutral-70));"
			class="u-x-small u-margin-block-start-12 u-text-center"
		>
			{$t('modal.agree_by_joining')}
			<a
				class="u-bold"
				href={isPreview
					? undefined
					: termsOfService
					? termsOfService
					: 'https://appwrite.io/policy/terms'}
				target="_blank"
				>{$t('modal.terms')}
			</a>
			{$t('general.and')}
			<a
				class="u-bold"
				href={isPreview
					? undefined
					: privacyPolicy
					? privacyPolicy
					: 'https://appwrite.io/policy/privacy'}
				target="_blank"
				>{$t('modal.privacy_policy')}
			</a>
		</p>
	{:else}
		<section class="card c-border-radius" style="width: 100%;">
			<div class="u-max-width-500 u-width-full-line">
				<div class="u-flex u-main-center">
					<img
						class="c-border-radius-logo"
						src={fileId ? AppwriteService.getLogo(fileId) : '/favicon.png'}
						height="64"
						alt="Logo"
					/>
				</div>
				<h1 class="heading-level-3 u-margin-block-start-auto u-margin-block-start-24 u-text-center">
					{$t('general.welcome')}
				</h1>
				<p class="u-text-center">
					{$t('modal.already_signed_in')}
					<span class="u-bold" style={`${darkTheme ? 'color: white;' : 'color: black;'}`}
						>{currentUser.name
							? currentUser.name
							: currentUser.email
							? currentUser.email
							: currentUser.phone
							? currentUser.phone
							: 'Anonymous'}</span
					>
				</p>
				<div class="u-margin-block-start-24">
					<div class="form common-section" data-hs-cf-bound="true">
						<ul class="form-list">
							<li class="form-item u-flex u-flex-vertical u-gap-8">
								<div class="form" data-hs-cf-bound="true">
									<ul class="form-list">
										<li class="form-item">
											<a href={isPreview ? undefined : successUrl}>
												<button class="c-branded-button button is-full-width" type="submit"
													>{$t('modal.back_website')}</button
												></a
											>

											<div
												style="margin: 1.5rem 0px; border-top: 0.0625rem solid hsl(var(--color-neutral-30));"
											/>

											{#if isSignOutLoading}
												<button
													class="button is-text u-flex u-main-center"
													style="width: 100%;"
													disabled={true}
													type="button"
												>
													<div class="loader" />
												</button>
											{:else}
												<button
													class="button is-secondary is-full-width"
													type="button"
													on:click={signOut}>{$t('general.signout')}</button
												>
											{/if}

											{#if signOutError}
												<div
													class="u-text-center u-bold u-margin-block-start-16"
													style="color: hsl(var(--color-text-danger))"
												>
													<p class="text">{signOutError}</p>
												</div>
											{/if}
										</li>
									</ul>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</section>
	{/if}
</div>
