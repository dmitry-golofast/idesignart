<script setup lang="ts">
import { computed } from 'vue'

useSeo({
  title: 'Контакты — idesignart',
  description: 'Свяжитесь со студией дизайна и визуализации. WhatsApp, Telegram, телефон, email.',
})

const { data: settings } = useSettings()
const contacts = computed(() => settings.value?.contacts || {})
const config = useRuntimeConfig()

const whatsappUrl = computed(() =>
  contacts.value.whatsapp ? `https://wa.me/${contacts.value.whatsapp}` : '',
)
const telegramUrl = computed(() =>
  contacts.value.telegram ? `https://t.me/${contacts.value.telegram}` : '',
)
</script>

<template>
  <div>
    <section class="bg-[var(--color-surface)] pt-32">
      <div class="container-app pb-8">
        <p class="eyebrow">Контакты</p>
        <h1 class="page-title mt-3">Свяжитесь с нами</h1>
        <p class="mt-4 max-w-xl text-lg text-[var(--color-ink-muted)]">
          Выберите удобный способ — ответим в течение рабочего дня.
        </p>

        <!-- Быстрые контакты -->
        <div class="mt-8 flex flex-wrap gap-3">
          <NuxtLink
            v-if="whatsappUrl"
            :to="whatsappUrl"
            external
            target="_blank"
            class="btn-lime"
          >
            <UIcon name="i-lucide-message-circle" class="h-4 w-4" aria-hidden="true" />
            WhatsApp
          </NuxtLink>
          <UButton
            v-if="telegramUrl"
            :to="telegramUrl"
            icon="i-lucide-send"
            color="neutral"
            variant="outline"
            size="lg"
            external
            target="_blank"
          >
            Telegram
          </UButton>
          <UButton
            v-if="contacts.phone || config.public.phone"
            :to="`tel:${contacts.phone || config.public.phone}`"
            icon="i-lucide-phone"
            color="neutral"
            variant="outline"
            size="lg"
          >
            {{ contacts.phone || config.public.phone }}
          </UButton>
          <UButton
            v-if="contacts.email || config.public.email"
            :to="`mailto:${contacts.email || config.public.email}`"
            icon="i-lucide-mail"
            color="neutral"
            variant="outline"
            size="lg"
          >
            {{ contacts.email || config.public.email }}
          </UButton>
        </div>
      </div>
    </section>

    <!-- Форма -->
    <BlocksContactForm
      eyebrow="Заявка"
      title="Или оставьте заявку"
      source="contacts-page"
    />
  </div>
</template>
