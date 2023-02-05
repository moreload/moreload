import Logger from 'lib/logger';
import { NextApiReq, NextApiRes, UserExtended, withMoreLoad } from 'middleware/withMoreLoad';

async function handler(req: NextApiReq, res: NextApiRes, user: UserExtended) {
  req.cleanCookie('user');

  Logger.get('user').info(`User ${user.username} (${user.id}) logged out`);

  return res.json({ success: true });
}

export default withMoreLoad(handler, {
  methods: ['GET'],
  user: true,
});
