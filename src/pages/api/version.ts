import { readFile } from 'fs/promises';
import config from 'lib/config';
import { NextApiReq, NextApiRes, withMoreLoad } from 'middleware/withMoreLoad';

async function handler(_: NextApiReq, res: NextApiRes) {
  if (!config.website.show_version) return res.forbidden('version hidden');

  const pkg = JSON.parse(await readFile('package.json', 'utf8'));

  const re = await fetch('https://raw.githubusercontent.com/moreload/moreload/trunk/package.json');
  const upstreamPkg = await re.json();

  return res.json({
    local: pkg.version,
    upstream: upstreamPkg.version,
  });
}

export default withMoreLoad(handler, {
  methods: ['GET'],
  user: true,
});
