// VSCodium patches - Bun runtime
const outDir = Bun.argv[2];
const cssPath = Bun.argv[3];

if (!outDir || !cssPath) throw new Error('Expected outDir and cssPath arguments');

console.log('Running VSCodium patches');

// Read CSS at runtime (during postInstall)
const cssContent = await Bun.file(cssPath).text();

// Patch product.json
const productJsonPath = `${outDir}/lib/vscode/resources/app/product.json`;
const productData = await Bun.file(productJsonPath).json();

productData.extensionsGallery = {
	serviceUrl: 'https://marketplace.visualstudio.com/_apis/public/gallery',
	controlUrl: 'https://main.vscode-cdn.net/extensions/marketplace.json',
	itemUrl: 'https://marketplace.visualstudio.com/items',
	cacheUrl: 'https://vscode.blob.core.windows.net/gallery/index',
};

await Bun.write(productJsonPath, JSON.stringify(productData, null, 2));

// Patch workbench.html
const workbenchHtmlPath = `${outDir}/lib/vscode/resources/app/out/vs/code/electron-browser/workbench/workbench.html`;
const htmlContent = await Bun.file(workbenchHtmlPath).text();

if (!htmlContent.includes('</head>')) throw new Error('Expected </head> in workbench.html');

const patched = htmlContent.replace('</head>', `<style>${cssContent}</style></head>`);
await Bun.write(workbenchHtmlPath, patched);

export { };
