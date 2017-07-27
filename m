Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08B9C21D09190
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 08:12:42 -0700 (PDT)
Date: Thu, 27 Jul 2017 18:14:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] libnvdimm: control (ioctl) messages for nvdimm_bus and
 nvdimm devices
Message-ID: <20170727151432.kiff55pjm227dycb@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello Dan Williams,

The patch 62232e45f4a2: "libnvdimm: control (ioctl) messages for
nvdimm_bus and nvdimm devices" from Jun 8, 2015, leads to the
following static checker warning:

	drivers/nvdimm/bus.c:1018 __nd_ioctl()
	warn: integer overflows 'buf_len'

drivers/nvdimm/bus.c
   959          /* process an input envelope */
   960          for (i = 0; i < desc->in_num; i++) {
   961                  u32 in_size, copy;
   962  
   963                  in_size = nd_cmd_in_size(nvdimm, cmd, desc, i, in_env);
   964                  if (in_size == UINT_MAX) {
   965                          dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
   966                                          __func__, dimm_name, cmd_name, i);
   967                          return -ENXIO;
   968                  }
   969                  if (in_len < sizeof(in_env))
   970                          copy = min_t(u32, sizeof(in_env) - in_len, in_size);
   971                  else
   972                          copy = 0;
   973                  if (copy && copy_from_user(&in_env[in_len], p + in_len, copy))
   974                          return -EFAULT;
   975                  in_len += in_size;


>From a casual review, this seems like it might be a real bug.  On the
first iteration we load some data into in_env[].  On the second
iteration we read a use controlled "in_size" from nd_cmd_in_size().  It
can go up to UINT_MAX - 1.  A high number means we will fill the whole
in_env[] buffer.  But we potentially keep looping and adding more to
in_len so now it can be any value.

It simple enough to change:

-			in_len += in_size;
+			in_len += copy;

But it feels weird that we keep looping even though in_env is totally
full.  Shouldn't we just return an error if we don't have space for
desc->in_num.

   976          }
   977  
   978          if (cmd == ND_CMD_CALL) {
   979                  func = pkg.nd_command;
   980                  dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
   981                                  __func__, dimm_name, pkg.nd_command,
   982                                  in_len, out_len, buf_len);
   983  
   984                  for (i = 0; i < ARRAY_SIZE(pkg.nd_reserved2); i++)
   985                          if (pkg.nd_reserved2[i])
   986                                  return -EINVAL;
   987          }
   988  
   989          /* process an output envelope */
   990          for (i = 0; i < desc->out_num; i++) {
   991                  u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
   992                                  (u32 *) in_env, (u32 *) out_env, 0);
   993                  u32 copy;
   994  
   995                  if (out_size == UINT_MAX) {
   996                          dev_dbg(dev, "%s:%s unknown output size cmd: %s field: %d\n",
   997                                          __func__, dimm_name, cmd_name, i);
   998                          return -EFAULT;
   999                  }
  1000                  if (out_len < sizeof(out_env))
  1001                          copy = min_t(u32, sizeof(out_env) - out_len, out_size);
  1002                  else
  1003                          copy = 0;
  1004                  if (copy && copy_from_user(&out_env[out_len],
  1005                                          p + in_len + out_len, copy))
  1006                          return -EFAULT;
  1007                  out_len += out_size;

Same thing.

  1008          }
  1009  
  1010          buf_len = out_len + in_len;

It means this addition could overflow.

  1011          if (buf_len > ND_IOCTL_MAX_BUFLEN) {
  1012                  dev_dbg(dev, "%s:%s cmd: %s buf_len: %zu > %d\n", __func__,
  1013                                  dimm_name, cmd_name, buf_len,
  1014                                  ND_IOCTL_MAX_BUFLEN);
  1015                  return -EINVAL;
  1016          }
  1017  
  1018          buf = vmalloc(buf_len);
                              ^^^^^^^
The checker complains we might allocate less than intended.

  1019          if (!buf)
  1020                  return -ENOMEM;
  1021  
  1022          if (copy_from_user(buf, p, buf_len)) {
  1023                  rc = -EFAULT;
  1024                  goto out;
  1025          }

regards,
dan carpenter
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
