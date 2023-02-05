import { PrismaClient } from '@prisma/client';

if (!global.prisma) {
  if (!process.env.MORELOAD_DOCKER_BUILD) global.prisma = new PrismaClient();
}

export default global.prisma as PrismaClient;
