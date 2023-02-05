import Logger from 'lib/logger';
import prisma from 'lib/prisma';
import { createToken } from 'lib/util';
import { NextApiReq, NextApiRes, UserExtended, withMoreLoad } from 'middleware/withMoreLoad';

async function handler(_: NextApiReq, res: NextApiRes, user: UserExtended) {
  const updated = await prisma.user.update({
    where: {
      id: user.id,
    },
    data: {
      token: createToken(),
    },
  });

  Logger.get('user').info(`User ${user.username} (${user.id}) reset their token`);

  return res.json({ success: updated.token });
}

export default withMoreLoad(handler, {
  methods: ['PATCH'],
  user: true,
});
