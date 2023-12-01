import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightBlog from 'starlight-blog';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlightBlog(),
		starlight({
			components: {
	       		MarkdownContent: 'starlight-blog/overrides/MarkdownContent.astro',
	        	Sidebar: 'starlight-blog/overrides/Sidebar.astro',
	       		ThemeSelect: 'starlight-blog/overrides/ThemeSelect.astro',
       		},
			title: 'Akashi Systems',
			social: {
				github: 'https://github.com/mvkvc/akashi',
			},
			sidebar: [
				{
					label: 'Guides',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'Example Guide', link: '/guides/example/' },
					],
				},
				{
					label: 'Reference',
					autogenerate: { directory: 'reference' },
				},
			],
		}),
	],
});
