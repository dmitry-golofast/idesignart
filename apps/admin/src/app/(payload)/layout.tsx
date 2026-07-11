/* THIS FILE WAS GENERATED AUTOMATICALLY BY PAYLOAD. */
/* DO NOT MODIFY IT BECAUSE IT COULD BE REWRITTEN AT ANY TIME. */
import type { ServerFunctionClient } from 'payload'
import config from '@payload-config'
import { importMap } from './admin/importMap'
import { RootLayout } from '@payloadcms/next/layouts'

import { serverFunction } from './server-function'
import '@payloadcms/next/css'

export const metadata = {
  title: 'Payload — idesignart Admin',
  description: 'Управление контентом сайта',
}

type Args = {
  children: React.ReactNode
}

const Layout = ({ children }: Args) => (
  <RootLayout config={config} importMap={importMap} serverFunction={serverFunction}>
    {children}
  </RootLayout>
)

export default Layout
