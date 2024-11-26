<script lang="ts">
	import { Account, Client, ID, type Models } from 'appwrite';
	import { t } from 'svelte-i18n';

	export let allowMagicUrl: boolean = false;
	export let allowEmailOtp: boolean = false;
	export let successUrl: string = '';
	export let isPreview = false;
	export let getClient: () => Client;

	let emailOtpToken: null | Models.Token = null;

	let email = '';
	let code = '';

	let isLoading = false;
	let error = '';

	let sent = false;

	async function onSubmit() {
		if (isLoading) {
			return;
		}

		isLoading = true;
		error = '';

		try {
			const account = new Account(getClient());

			if (allowMagicUrl) {
				await account.createMagicURLToken(
					ID.unique(),
					email,
					document.location.origin + '/email-login-finish'
				);
			}

			if (allowEmailOtp) {
				emailOtpToken = await account.createEmailToken(ID.unique(), email);
			}

			sent = true;
			isLoading = false;
		} catch (err: any) {
			error = err.message;
			isLoading = false;
		}
	}

	async function onFinish() {
		if (isLoading || !emailOtpToken) {
			return;
		}

		isLoading = true;
		error = '';

		try {
			const account = new Account(getClient());
			await account.createSession(emailOtpToken.userId, `${code}`);

			window.location.href = successUrl;
		} catch (err: any) {
			error = err.message;
			isLoading = false;
		}
	}
</script>

<li class="form-item u-flex u-flex-vertical u-gap-8">
	{#if !sent}
		<form on:submit|preventDefault={onSubmit} class="form" data-hs-cf-bound="true">
			<ul class="form-list">
				<li class="form-item">
					<label class="label is-required" for="email">{$t('general.email')}</label>
					<div class="input-text-wrapper">
						<input
							bind:value={email}
							id="email"
							placeholder="Email"
							required={true}
							type="email"
							class="input-text"
							autocomplete="off"
						/>
					</div>
				</li>
				<li class="form-item">
					{#if isLoading}
						<button
							class="button is-text u-flex u-main-center"
							style="width: 100%;"
							disabled={true}
							type="button"
						>
							<div class="loader" />
						</button>
					{:else}
						<button class="c-branded-button button is-full-width" type="submit"
							>{$t('general.signin')}</button
						>
					{/if}

					{#if error}
						<div
							class="u-text-center u-bold u-margin-block-start-16"
							style="color: hsl(var(--color-text-danger))"
						>
							<p class="text">{error}</p>
						</div>
					{/if}

					<ul class="inline-links is-center is-with-sep u-margin-block-start-16">
						<li class="inline-links-item">
							<a href={isPreview ? undefined : '/'} type="button"
								><span class="text">{$t('general.other_methods')}</span></a
							>
						</li>
					</ul>
				</li>
			</ul>
		</form>
	{:else}
		{#if allowMagicUrl}
			<ul class="form-list">
				<section class="alert-sticky is-success" style="width: 100%;">
					<div class="alert-sticky-image"><span class="icon-info" aria-hidden="true" /></div>
					<div class="alert-sticky-content">
						<h4 class="alert-sticky-title">{$t('form.magic.signin_sent')}</h4>
						<p>{$t('form.magic.check_inbox')}</p>
					</div>
				</section>

				<li class="form-item">
					<ul class="inline-links is-center is-with-sep u-margin-block-start-16">
						<li class="inline-links-item">
							<button
								on:click={() => {
									sent = false;
									email = '';
								}}
								type="button"><span class="text">{$t('general.try_again')}</span></button
							>
						</li>
					</ul>
				</li>
			</ul>
		{/if}
		{#if allowEmailOtp}
			<ul class="form-list">
				<section class="alert-sticky is-success" style="width: 100%;">
					<div class="alert-sticky-image"><span class="icon-info" aria-hidden="true" /></div>
					<div class="alert-sticky-content">
						<h4 class="alert-sticky-title">{$t('form.magic.signin_sent')}</h4>
						<p>{$t('form.magic.check_inbox')}</p>
					</div>
				</section>

				<li class="form-item">
					<form on:submit|preventDefault={onFinish}>
						<ul class="form-list">
							<li class="form-item">
								<label class="label is-required" for="code">{$t('general.code')}</label>
								<div class="input-text-wrapper">
									<input
										bind:value={code}
										id="code"
										placeholder="6-digit code"
										required={true}
										type="number"
										class="input-text"
										autocomplete="off"
									/>
								</div>
							</li>
							<li class="form-item">
								{#if isLoading}
									<button
										class="button is-text u-flex u-main-center"
										style="width: 100%;"
										disabled={true}
										type="button"
									>
										<div class="loader" />
									</button>
								{:else}
									<button class="c-branded-button button is-full-width" type="submit"
										>{$t('general.signin')}</button
									>
								{/if}

								{#if error}
									<div
										class="u-text-center u-bold u-margin-block-start-16"
										style="color: hsl(var(--color-text-danger))"
									>
										<p class="text">{error}</p>
									</div>
								{/if}
							</li>
						</ul>
					</form>
				</li>

				<li class="form-item">
					<ul class="inline-links is-center is-with-sep u-margin-block-start-16">
						<li class="inline-links-item">
							<button
								on:click={() => {
									sent = false;
									email = '';
								}}
								type="button"><span class="text">{$t('general.try_again')}</span></button
							>
						</li>
					</ul>
				</li>
			</ul>
		{/if}
	{/if}
</li>
