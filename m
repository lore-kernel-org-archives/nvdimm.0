Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD871DFDE;
	Tue, 23 Sep 2025 01:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758592704; cv=none; b=M807+xC2/H3z88EVWHArqubtJj7pKhE5KfqJY8iF3rSIsFAzmKR9ArObtOulWwnOn49Tb7JnRtWbzLD2hZbNJu2eySMoSlPvMFV4JhWNch2hPstHgwq1GxF+1Q5Sw6WyIY06X0mWLiPF0tTxaDagU7aENFlPpzJdXxp9HcXLZ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758592704; c=relaxed/simple;
	bh=YEs03z5rgC1BMbMg5Gk8XJLG3uGg9PsR4Zl58rFzw+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvEBtKbljwRItT+zRU4QjyDFEQucpv0091WhDqcJdTi5NJovwuoMoj7Nvbh35T+5/3IDuRvY5LRM2q2AdAGAkaDfq76+gXD48bL+YYOoEGaJ7Zm43UNHBVZUBq8mmjQnInrR91VzjtzBWxwHxSvPmVcyOIFSg6s/dt/OmtqGQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NM5O7rhl; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NM5O7rhl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758592703; x=1790128703;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YEs03z5rgC1BMbMg5Gk8XJLG3uGg9PsR4Zl58rFzw+E=;
  b=NM5O7rhlpdA02QiGArTDydoKRr9fULk9stV/wfKC4DyR1u3DyrFOc3yi
   0Wvz9/j0L4OBXe9WEODZA5UhfZ12njnFxPtgl6xmK472FcuwnLf5+ZcRn
   MixVEdtm57t4yybRvVggoG9maIrOlwuUAja956dzQ5tAZ3Jxm5qoLTP9V
   rJZ/9h2MRLZbY+IOrlvJWUEU+6UjsoTiayi1QExR72JX/Z+B1ltE82nBT
   /nI+3BZOJsr3ZVjBFh1bGjXRy5/kWemjcoApXNbJPRUqiuu/g4xddR8F1
   3YwWwHMmrt5z8/vyk9djP+LHhtKgxNXx6Y+YQy2OXfF/7tYArW2Zg9+It
   g==;
X-CSE-ConnectionGUID: 2t5GOIdBTCC1Qaf0SRs+ZA==
X-CSE-MsgGUID: EUhofYzHQguO3WlKGtnrqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72288941"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="72288941"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 18:58:21 -0700
X-CSE-ConnectionGUID: 53WVsh3OSUqoYVn6esm34A==
X-CSE-MsgGUID: JKLHVKUySn6U+QQKxJsQzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176558190"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 22 Sep 2025 18:58:18 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0sIJ-0002e1-35;
	Tue, 23 Sep 2025 01:58:15 +0000
Date: Tue, 23 Sep 2025 09:58:01 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ira.weiny@intel.com, vishal.l.verma@intel.com,
	dan.j.williams@intel.com, jonathan.cameron@huawei.com,
	s.neeraj@samsung.com
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
Message-ID: <202509230941.jMdKMPL8-lkp@intel.com>
References: <20250922211330.1433044-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922211330.1433044-1-dave.jiang@intel.com>

Hi Dave,

kernel test robot noticed the following build errors:

[auto build test ERROR on 07e27ad16399afcd693be20211b0dfae63e0615f]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Jiang/nvdimm-Introduce-guard-for-nvdimm_bus_lock/20250923-051440
base:   07e27ad16399afcd693be20211b0dfae63e0615f
patch link:    https://lore.kernel.org/r/20250922211330.1433044-1-dave.jiang%40intel.com
patch subject: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
config: x86_64-buildonly-randconfig-006-20250923 (https://download.01.org/0day-ci/archive/20250923/202509230941.jMdKMPL8-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509230941.jMdKMPL8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509230941.jMdKMPL8-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/nvdimm/bus.c:1175:3: error: cannot jump from this goto statement to its label
    1175 |                 goto out;
         |                 ^
   drivers/nvdimm/bus.c:1179:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1179 |         guard(nvdimm_bus)(dev);
         |         ^
   include/linux/cleanup.h:401:15: note: expanded from macro 'guard'
     401 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:166:29: note: expanded from macro '__UNIQUE_ID'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^
   include/linux/compiler_types.h:84:22: note: expanded from macro '__PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^
   include/linux/compiler_types.h:83:23: note: expanded from macro '___PASTE'
      83 | #define ___PASTE(a,b) a##b
         |                       ^
   <scratch space>:93:1: note: expanded from here
      93 | __UNIQUE_ID_guard458
         | ^
   drivers/nvdimm/bus.c:1178:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1178 |         guard(device)(dev);
         |         ^
   include/linux/cleanup.h:401:15: note: expanded from macro 'guard'
     401 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:166:29: note: expanded from macro '__UNIQUE_ID'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^
   include/linux/compiler_types.h:84:22: note: expanded from macro '__PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^
   include/linux/compiler_types.h:83:23: note: expanded from macro '___PASTE'
      83 | #define ___PASTE(a,b) a##b
         |                       ^
   <scratch space>:84:1: note: expanded from here
      84 | __UNIQUE_ID_guard457
         | ^
   drivers/nvdimm/bus.c:1170:3: error: cannot jump from this goto statement to its label
    1170 |                 goto out;
         |                 ^
   drivers/nvdimm/bus.c:1179:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1179 |         guard(nvdimm_bus)(dev);
         |         ^
   include/linux/cleanup.h:401:15: note: expanded from macro 'guard'
     401 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:166:29: note: expanded from macro '__UNIQUE_ID'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^
   include/linux/compiler_types.h:84:22: note: expanded from macro '__PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^
   include/linux/compiler_types.h:83:23: note: expanded from macro '___PASTE'
      83 | #define ___PASTE(a,b) a##b
         |                       ^
   <scratch space>:93:1: note: expanded from here
      93 | __UNIQUE_ID_guard458
         | ^
   drivers/nvdimm/bus.c:1178:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1178 |         guard(device)(dev);
         |         ^
   include/linux/cleanup.h:401:15: note: expanded from macro 'guard'
     401 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:166:29: note: expanded from macro '__UNIQUE_ID'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^
   include/linux/compiler_types.h:84:22: note: expanded from macro '__PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^
   include/linux/compiler_types.h:83:23: note: expanded from macro '___PASTE'
      83 | #define ___PASTE(a,b) a##b
         |                       ^
   <scratch space>:84:1: note: expanded from here
      84 | __UNIQUE_ID_guard457
         | ^
   drivers/nvdimm/bus.c:1164:3: error: cannot jump from this goto statement to its label
    1164 |                 goto out;
         |                 ^
   drivers/nvdimm/bus.c:1179:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1179 |         guard(nvdimm_bus)(dev);
         |         ^
   include/linux/cleanup.h:401:15: note: expanded from macro 'guard'
     401 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:166:29: note: expanded from macro '__UNIQUE_ID'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^
   include/linux/compiler_types.h:84:22: note: expanded from macro '__PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^
   include/linux/compiler_types.h:83:23: note: expanded from macro '___PASTE'
      83 | #define ___PASTE(a,b) a##b
         |                       ^
   <scratch space>:93:1: note: expanded from here
      93 | __UNIQUE_ID_guard458
         | ^
   drivers/nvdimm/bus.c:1178:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
    1178 |         guard(device)(dev);


vim +1175 drivers/nvdimm/bus.c

eaf961536e1622 Dan Williams  2015-05-01  1023  
62232e45f4a265 Dan Williams  2015-06-08  1024  static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
62232e45f4a265 Dan Williams  2015-06-08  1025  		int read_only, unsigned int ioctl_cmd, unsigned long arg)
62232e45f4a265 Dan Williams  2015-06-08  1026  {
62232e45f4a265 Dan Williams  2015-06-08  1027  	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
62232e45f4a265 Dan Williams  2015-06-08  1028  	const struct nd_cmd_desc *desc = NULL;
62232e45f4a265 Dan Williams  2015-06-08  1029  	unsigned int cmd = _IOC_NR(ioctl_cmd);
62232e45f4a265 Dan Williams  2015-06-08  1030  	struct device *dev = &nvdimm_bus->dev;
58738c495e15ba Dan Williams  2017-08-31  1031  	void __user *p = (void __user *) arg;
6de5d06e657acd Dan Williams  2019-07-17  1032  	char *out_env = NULL, *in_env = NULL;
62232e45f4a265 Dan Williams  2015-06-08  1033  	const char *cmd_name, *dimm_name;
58738c495e15ba Dan Williams  2017-08-31  1034  	u32 in_len = 0, out_len = 0;
58738c495e15ba Dan Williams  2017-08-31  1035  	unsigned int func = cmd;
e3654eca70d637 Dan Williams  2016-04-28  1036  	unsigned long cmd_mask;
58738c495e15ba Dan Williams  2017-08-31  1037  	struct nd_cmd_pkg pkg;
006358b35c73ab Dave Jiang    2017-04-07  1038  	int rc, i, cmd_rc;
6de5d06e657acd Dan Williams  2019-07-17  1039  	void *buf = NULL;
58738c495e15ba Dan Williams  2017-08-31  1040  	u64 buf_len = 0;
62232e45f4a265 Dan Williams  2015-06-08  1041  
62232e45f4a265 Dan Williams  2015-06-08  1042  	if (nvdimm) {
62232e45f4a265 Dan Williams  2015-06-08  1043  		desc = nd_cmd_dimm_desc(cmd);
62232e45f4a265 Dan Williams  2015-06-08  1044  		cmd_name = nvdimm_cmd_name(cmd);
e3654eca70d637 Dan Williams  2016-04-28  1045  		cmd_mask = nvdimm->cmd_mask;
62232e45f4a265 Dan Williams  2015-06-08  1046  		dimm_name = dev_name(&nvdimm->dev);
62232e45f4a265 Dan Williams  2015-06-08  1047  	} else {
62232e45f4a265 Dan Williams  2015-06-08  1048  		desc = nd_cmd_bus_desc(cmd);
62232e45f4a265 Dan Williams  2015-06-08  1049  		cmd_name = nvdimm_bus_cmd_name(cmd);
e3654eca70d637 Dan Williams  2016-04-28  1050  		cmd_mask = nd_desc->cmd_mask;
62232e45f4a265 Dan Williams  2015-06-08  1051  		dimm_name = "bus";
62232e45f4a265 Dan Williams  2015-06-08  1052  	}
62232e45f4a265 Dan Williams  2015-06-08  1053  
92fe2aa859f52c Dan Williams  2020-07-20  1054  	/* Validate command family support against bus declared support */
31eca76ba2fc98 Dan Williams  2016-04-28  1055  	if (cmd == ND_CMD_CALL) {
92fe2aa859f52c Dan Williams  2020-07-20  1056  		unsigned long *mask;
92fe2aa859f52c Dan Williams  2020-07-20  1057  
31eca76ba2fc98 Dan Williams  2016-04-28  1058  		if (copy_from_user(&pkg, p, sizeof(pkg)))
31eca76ba2fc98 Dan Williams  2016-04-28  1059  			return -EFAULT;
92fe2aa859f52c Dan Williams  2020-07-20  1060  
92fe2aa859f52c Dan Williams  2020-07-20  1061  		if (nvdimm) {
92fe2aa859f52c Dan Williams  2020-07-20  1062  			if (pkg.nd_family > NVDIMM_FAMILY_MAX)
92fe2aa859f52c Dan Williams  2020-07-20  1063  				return -EINVAL;
92fe2aa859f52c Dan Williams  2020-07-20  1064  			mask = &nd_desc->dimm_family_mask;
92fe2aa859f52c Dan Williams  2020-07-20  1065  		} else {
92fe2aa859f52c Dan Williams  2020-07-20  1066  			if (pkg.nd_family > NVDIMM_BUS_FAMILY_MAX)
92fe2aa859f52c Dan Williams  2020-07-20  1067  				return -EINVAL;
92fe2aa859f52c Dan Williams  2020-07-20  1068  			mask = &nd_desc->bus_family_mask;
92fe2aa859f52c Dan Williams  2020-07-20  1069  		}
92fe2aa859f52c Dan Williams  2020-07-20  1070  
92fe2aa859f52c Dan Williams  2020-07-20  1071  		if (!test_bit(pkg.nd_family, mask))
92fe2aa859f52c Dan Williams  2020-07-20  1072  			return -EINVAL;
31eca76ba2fc98 Dan Williams  2016-04-28  1073  	}
31eca76ba2fc98 Dan Williams  2016-04-28  1074  
f84afbdd3a9e5e Dan Carpenter 2020-02-25  1075  	if (!desc ||
f84afbdd3a9e5e Dan Carpenter 2020-02-25  1076  	    (desc->out_num + desc->in_num == 0) ||
f84afbdd3a9e5e Dan Carpenter 2020-02-25  1077  	    cmd > ND_CMD_CALL ||
e3654eca70d637 Dan Williams  2016-04-28  1078  	    !test_bit(cmd, &cmd_mask))
62232e45f4a265 Dan Williams  2015-06-08  1079  		return -ENOTTY;
62232e45f4a265 Dan Williams  2015-06-08  1080  
62232e45f4a265 Dan Williams  2015-06-08  1081  	/* fail write commands (when read-only) */
62232e45f4a265 Dan Williams  2015-06-08  1082  	if (read_only)
07accfa9d1a8ba Jerry Hoemann 2016-01-06  1083  		switch (cmd) {
07accfa9d1a8ba Jerry Hoemann 2016-01-06  1084  		case ND_CMD_VENDOR:
07accfa9d1a8ba Jerry Hoemann 2016-01-06  1085  		case ND_CMD_SET_CONFIG_DATA:
07accfa9d1a8ba Jerry Hoemann 2016-01-06  1086  		case ND_CMD_ARS_START:
d4f323672aa637 Dan Williams  2016-03-03  1087  		case ND_CMD_CLEAR_ERROR:
31eca76ba2fc98 Dan Williams  2016-04-28  1088  		case ND_CMD_CALL:
ca6bf264f6d856 Dan Williams  2019-07-17  1089  			dev_dbg(dev, "'%s' command while read-only.\n",
62232e45f4a265 Dan Williams  2015-06-08  1090  					nvdimm ? nvdimm_cmd_name(cmd)
62232e45f4a265 Dan Williams  2015-06-08  1091  					: nvdimm_bus_cmd_name(cmd));
62232e45f4a265 Dan Williams  2015-06-08  1092  			return -EPERM;
62232e45f4a265 Dan Williams  2015-06-08  1093  		default:
62232e45f4a265 Dan Williams  2015-06-08  1094  			break;
62232e45f4a265 Dan Williams  2015-06-08  1095  		}
62232e45f4a265 Dan Williams  2015-06-08  1096  
62232e45f4a265 Dan Williams  2015-06-08  1097  	/* process an input envelope */
6de5d06e657acd Dan Williams  2019-07-17  1098  	in_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
6de5d06e657acd Dan Williams  2019-07-17  1099  	if (!in_env)
6de5d06e657acd Dan Williams  2019-07-17  1100  		return -ENOMEM;
62232e45f4a265 Dan Williams  2015-06-08  1101  	for (i = 0; i < desc->in_num; i++) {
62232e45f4a265 Dan Williams  2015-06-08  1102  		u32 in_size, copy;
62232e45f4a265 Dan Williams  2015-06-08  1103  
62232e45f4a265 Dan Williams  2015-06-08  1104  		in_size = nd_cmd_in_size(nvdimm, cmd, desc, i, in_env);
62232e45f4a265 Dan Williams  2015-06-08  1105  		if (in_size == UINT_MAX) {
62232e45f4a265 Dan Williams  2015-06-08  1106  			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
62232e45f4a265 Dan Williams  2015-06-08  1107  					__func__, dimm_name, cmd_name, i);
6de5d06e657acd Dan Williams  2019-07-17  1108  			rc = -ENXIO;
6de5d06e657acd Dan Williams  2019-07-17  1109  			goto out;
45def22c1fab85 Dan Williams  2015-04-26  1110  		}
6de5d06e657acd Dan Williams  2019-07-17  1111  		if (in_len < ND_CMD_MAX_ENVELOPE)
6de5d06e657acd Dan Williams  2019-07-17  1112  			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - in_len, in_size);
62232e45f4a265 Dan Williams  2015-06-08  1113  		else
62232e45f4a265 Dan Williams  2015-06-08  1114  			copy = 0;
6de5d06e657acd Dan Williams  2019-07-17  1115  		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy)) {
6de5d06e657acd Dan Williams  2019-07-17  1116  			rc = -EFAULT;
6de5d06e657acd Dan Williams  2019-07-17  1117  			goto out;
6de5d06e657acd Dan Williams  2019-07-17  1118  		}
62232e45f4a265 Dan Williams  2015-06-08  1119  		in_len += in_size;
62232e45f4a265 Dan Williams  2015-06-08  1120  	}
62232e45f4a265 Dan Williams  2015-06-08  1121  
31eca76ba2fc98 Dan Williams  2016-04-28  1122  	if (cmd == ND_CMD_CALL) {
53b85a449b15e0 Jerry Hoemann 2017-06-30  1123  		func = pkg.nd_command;
426824d63b77bd Dan Williams  2018-03-05  1124  		dev_dbg(dev, "%s, idx: %llu, in: %u, out: %u, len %llu\n",
426824d63b77bd Dan Williams  2018-03-05  1125  				dimm_name, pkg.nd_command,
31eca76ba2fc98 Dan Williams  2016-04-28  1126  				in_len, out_len, buf_len);
31eca76ba2fc98 Dan Williams  2016-04-28  1127  	}
31eca76ba2fc98 Dan Williams  2016-04-28  1128  
62232e45f4a265 Dan Williams  2015-06-08  1129  	/* process an output envelope */
6de5d06e657acd Dan Williams  2019-07-17  1130  	out_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
6de5d06e657acd Dan Williams  2019-07-17  1131  	if (!out_env) {
6de5d06e657acd Dan Williams  2019-07-17  1132  		rc = -ENOMEM;
6de5d06e657acd Dan Williams  2019-07-17  1133  		goto out;
6de5d06e657acd Dan Williams  2019-07-17  1134  	}
6de5d06e657acd Dan Williams  2019-07-17  1135  
62232e45f4a265 Dan Williams  2015-06-08  1136  	for (i = 0; i < desc->out_num; i++) {
62232e45f4a265 Dan Williams  2015-06-08  1137  		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
efda1b5d87cbc3 Dan Williams  2016-12-06  1138  				(u32 *) in_env, (u32 *) out_env, 0);
62232e45f4a265 Dan Williams  2015-06-08  1139  		u32 copy;
62232e45f4a265 Dan Williams  2015-06-08  1140  
62232e45f4a265 Dan Williams  2015-06-08  1141  		if (out_size == UINT_MAX) {
426824d63b77bd Dan Williams  2018-03-05  1142  			dev_dbg(dev, "%s unknown output size cmd: %s field: %d\n",
426824d63b77bd Dan Williams  2018-03-05  1143  					dimm_name, cmd_name, i);
6de5d06e657acd Dan Williams  2019-07-17  1144  			rc = -EFAULT;
6de5d06e657acd Dan Williams  2019-07-17  1145  			goto out;
62232e45f4a265 Dan Williams  2015-06-08  1146  		}
6de5d06e657acd Dan Williams  2019-07-17  1147  		if (out_len < ND_CMD_MAX_ENVELOPE)
6de5d06e657acd Dan Williams  2019-07-17  1148  			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - out_len, out_size);
62232e45f4a265 Dan Williams  2015-06-08  1149  		else
62232e45f4a265 Dan Williams  2015-06-08  1150  			copy = 0;
62232e45f4a265 Dan Williams  2015-06-08  1151  		if (copy && copy_from_user(&out_env[out_len],
6de5d06e657acd Dan Williams  2019-07-17  1152  					p + in_len + out_len, copy)) {
6de5d06e657acd Dan Williams  2019-07-17  1153  			rc = -EFAULT;
6de5d06e657acd Dan Williams  2019-07-17  1154  			goto out;
6de5d06e657acd Dan Williams  2019-07-17  1155  		}
62232e45f4a265 Dan Williams  2015-06-08  1156  		out_len += out_size;
62232e45f4a265 Dan Williams  2015-06-08  1157  	}
62232e45f4a265 Dan Williams  2015-06-08  1158  
58738c495e15ba Dan Williams  2017-08-31  1159  	buf_len = (u64) out_len + (u64) in_len;
62232e45f4a265 Dan Williams  2015-06-08  1160  	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
426824d63b77bd Dan Williams  2018-03-05  1161  		dev_dbg(dev, "%s cmd: %s buf_len: %llu > %d\n", dimm_name,
426824d63b77bd Dan Williams  2018-03-05  1162  				cmd_name, buf_len, ND_IOCTL_MAX_BUFLEN);
6de5d06e657acd Dan Williams  2019-07-17  1163  		rc = -EINVAL;
6de5d06e657acd Dan Williams  2019-07-17  1164  		goto out;
62232e45f4a265 Dan Williams  2015-06-08  1165  	}
62232e45f4a265 Dan Williams  2015-06-08  1166  
62232e45f4a265 Dan Williams  2015-06-08  1167  	buf = vmalloc(buf_len);
6de5d06e657acd Dan Williams  2019-07-17  1168  	if (!buf) {
6de5d06e657acd Dan Williams  2019-07-17  1169  		rc = -ENOMEM;
6de5d06e657acd Dan Williams  2019-07-17  1170  		goto out;
6de5d06e657acd Dan Williams  2019-07-17  1171  	}
62232e45f4a265 Dan Williams  2015-06-08  1172  
62232e45f4a265 Dan Williams  2015-06-08  1173  	if (copy_from_user(buf, p, buf_len)) {
62232e45f4a265 Dan Williams  2015-06-08  1174  		rc = -EFAULT;
62232e45f4a265 Dan Williams  2015-06-08 @1175  		goto out;
62232e45f4a265 Dan Williams  2015-06-08  1176  	}
62232e45f4a265 Dan Williams  2015-06-08  1177  
eb0e82bc5f69da Dave Jiang    2025-09-22  1178  	guard(device)(dev);
eb0e82bc5f69da Dave Jiang    2025-09-22  1179  	guard(nvdimm_bus)(dev);
53b85a449b15e0 Jerry Hoemann 2017-06-30  1180  	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
eaf961536e1622 Dan Williams  2015-05-01  1181  	if (rc)
eb0e82bc5f69da Dave Jiang    2025-09-22  1182  		goto out;
eaf961536e1622 Dan Williams  2015-05-01  1183  
006358b35c73ab Dave Jiang    2017-04-07  1184  	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
62232e45f4a265 Dan Williams  2015-06-08  1185  	if (rc < 0)
eb0e82bc5f69da Dave Jiang    2025-09-22  1186  		goto out;
006358b35c73ab Dave Jiang    2017-04-07  1187  
006358b35c73ab Dave Jiang    2017-04-07  1188  	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
006358b35c73ab Dave Jiang    2017-04-07  1189  		struct nd_cmd_clear_error *clear_err = buf;
006358b35c73ab Dave Jiang    2017-04-07  1190  
23f4984483623c Dan Williams  2017-04-29  1191  		nvdimm_account_cleared_poison(nvdimm_bus, clear_err->address,
006358b35c73ab Dave Jiang    2017-04-07  1192  				clear_err->cleared);
006358b35c73ab Dave Jiang    2017-04-07  1193  	}
0beb2012a17226 Dan Williams  2017-04-07  1194  
62232e45f4a265 Dan Williams  2015-06-08  1195  	if (copy_to_user(p, buf, buf_len))
62232e45f4a265 Dan Williams  2015-06-08  1196  		rc = -EFAULT;
0beb2012a17226 Dan Williams  2017-04-07  1197  
62232e45f4a265 Dan Williams  2015-06-08  1198  out:
6de5d06e657acd Dan Williams  2019-07-17  1199  	kfree(in_env);
6de5d06e657acd Dan Williams  2019-07-17  1200  	kfree(out_env);
62232e45f4a265 Dan Williams  2015-06-08  1201  	vfree(buf);
62232e45f4a265 Dan Williams  2015-06-08  1202  	return rc;
62232e45f4a265 Dan Williams  2015-06-08  1203  }
62232e45f4a265 Dan Williams  2015-06-08  1204  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
