Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CF34CFCE
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806407; cv=none; b=gOo8toPzYxZICiDttyvFiYQJ2+zCAJJBw4gIrIeGz6tI81F/XPjzuXJKurp+y566oQ4458L94XpqxCOi3VLJsixKmNm15QTTCkH88M+jBK8+Nf1xgH2zkY/mlAYttZnz292ED9lUqqSLImjfxzyGhhnwvz3FEcczY7uAVEL7aKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806407; c=relaxed/simple;
	bh=Ttkg2XpXdV7mU4TtIvuypgDn9POxEKCuiqAdPxPROfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qkoidap0k6DmEoIzGk43uUudUN+kAWY8/FlLQlydo1PcUN9mtU/OOVWmSrkI3mDENS8UiC8KxhC8GbYhhYqAiFTZzYdOXlPoQ9TQ6CKx4E2XqRBciJEDkn0bmjlAKuQdtB7y2s6eNM9pWrccbteWPTNgl0ZyVj91YGpABY2g0MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2eDqjnI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2eDqjnI"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0d6f647e2so26376685ad.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 09:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806399; x=1768411199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=smDhjw69opHcgwAO6wrw0z059aJcdcN+GUjt6JFpHNc=;
        b=h2eDqjnID+MrYVdf6jzdPQm3hawhmkWsH6rmFrHPdUMxBU9nhhLdqzwfeMY34ruVdJ
         mGd7hijcXWuQuIlcRHJNJU4qfiPfnCsF7sVX0jV6FfdfI+2HqBMHEr1Ucy0x3+bVmqwT
         DoW/FhhBeu1R90Nq5Ll4FPLYGQFRg0OHXTLaPN2fOIfm5Xmyns8+ohLtGaMEFrr2V7s4
         RYSCyw3lRfhgue3HsUQl7zhoVmx4e1xjk1rzQfZIkBDdZ/RUKVjxtNfqNmlPbdPtI1gB
         IcUcZiMm9fYN+9N+vvD0yGjn2bCrm/4bnTtJnWReDCbmGxOdbmEjXeJHqoMgZvP0szBh
         1zCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806399; x=1768411199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smDhjw69opHcgwAO6wrw0z059aJcdcN+GUjt6JFpHNc=;
        b=JFi6MRHJDWUIMUJabybqS3ILlBK4guti9DEtJMxNzYSSXE5D8eVo5OJUfpy5s6/Xgj
         m2RgJs2tktNNLj3DySVyvRwgBy/2G0jCVFiM+fTmi5mLd0Xk+P+LAsgxfjLKYgdabJya
         i3RkCesfiiNxESt6lBN1N5e3onjnMqB2Ej0ivISe70/myIUO1jRXZKK+UhPDOEpwddgG
         lMEECROzEixJi6oPwHnaC6bP0bZZfWcWvLKkCEpuQ2TMB6t2jAzY6a8fnmjxRfGSHDCJ
         E6cNLV9bDVdo2M9lIl6mY0JDrVB+6YWzEsDz+dWUJ/oMKVCqTvOBnlO847O55CF0o4HU
         qZ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMrzuxfiUheFB77NV7H2hjTyBejUtgn8YoFgG6RMGYLcMVZ1t446G/FJVjlBjVCjBZyXXRmis=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWJdg8Q37Q3lrqc5RdFBG7/6rGQe6vzePE9pGjiVaADaikGqcr
	wAXNl3Ve/dPmbwQuLvWwWApmkUStAPrC1UtNSPDMGvrK4r/WLh67rlJH7a46Dw==
X-Gm-Gg: AY/fxX5zM31XJV+IeThWQzai/RSd1qI6p9YLw4eaR1dmIfFtX9Aa2pGLneB7X08vOxs
	Oz2QJ/wFeZoWtkO9IJ8fw+E3TgKN/xpI3pCvQFWZznmyrTAC1iWIM+tW7Rjy0X8ovV/Y59/a8hK
	NqRy5+JxQcIFvWDtjwD2xfwwTZCyUxhpp7u+S+lum9AmUIs9/HMpp2u7cd2/SwzJqr86LChxexx
	sQuBWwB5UCQSPIz6Xho83UW9vVv1Znw6nOtrsDWvThVoChOoVr8UnF+nVkHHyZCye7xJ/TNDm0v
	VWyVBuBMvSJ3b+TqhtnNXvVr2v4gCBcQEzvCiCJJ3R4BoVBvaQ7RMi60NKSSF4kNqIfbN8rCxtf
	jsCFrm4fUNHtbuaeQgHgpHAgaC4heS52Ln9RF9/NT2JXBbGMqk1XyfnpnFxI3rS5RVstyAwj9CU
	w0JE+uRvLhVeuc6EHATBt7rpkkiXMUUw1IfpItxdI/MqB3
X-Google-Smtp-Source: AGHT+IGk3VZwDE/lNocDKTrmheVpB/dJskVwCoQ351Cwl656mI6EkUE/J2SR25sUuHffBBW1+p+c1g==
X-Received: by 2002:a05:6808:668c:10b0:45a:7773:9013 with SMTP id 5614622812f47-45a77739cc0mr200634b6e.21.1767799968204;
        Wed, 07 Jan 2026 07:32:48 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478af8b2sm3393292a34.15.2026.01.07.07.32.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:32:47 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH BUNDLE] famfs: Fabric-Attached Memory File System
Date: Wed,  7 Jan 2026 09:32:44 -0600
Message-ID: <20260107153244.64703-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a coordinated patch submission for famfs (Fabric-Attached Memory
File System) across three repositories:

  1. Linux kernel (21 patches) - dax fsdev driver + fuse/famfs integration
  2. libfuse (4 patches) - famfs protocol support for fuse servers
  3. ndctl/daxctl (2 patches) - support for the new "famfs" devdax mode

Each series is posted as a reply to this cover message, with individual
patches replying to their respective series cover.

Overview
--------
Famfs exposes shared memory as a file system. It consumes shared memory
from dax devices and provides memory-mappable files that map directly to
the memory with no page cache involvement. Famfs differs from conventional
file systems in fs-dax mode in that it handles in-memory metadata in a
sharable way (which begins with never caching dirty shared metadata).

Famfs started as a standalone file system [1,2], but the consensus at
LSFMM 2024 and 2025 [3,4] was that it should be ported into fuse.

The key performance requirement is that famfs must resolve mapping faults
without upcalls. This is achieved by fully caching the file-to-devdax
metadata for all active files via two fuse client/server message/response
pairs: GET_FMAP and GET_DAXDEV.

Patch Series Summary
--------------------

Linux Kernel (V3, 21 patches):
  - dax: New fsdev driver (drivers/dax/fsdev.c) providing a devdax mode
    compatible with fs-dax. Devices can be switched among 'devdax', 'fsdev'
    and 'system-ram' modes via daxctl or sysfs.
  - fuse: Famfs integration adding GET_FMAP and GET_DAXDEV messages for
    caching file-to-dax mappings in the kernel.

libfuse (V2, 4 patches):
  - Updates fuse_kernel.h to kernel 6.19 baseline
  - Adds famfs DAX fmap protocol definitions
  - Adds API for kernel mount options
  - Implements famfs DAX fmap support for fuse servers

ndctl/daxctl (2 patches):
  - Adds daxctl support for the new "famfs" mode of devdax
  - Adds test/daxctl-famfs.sh for testing mode transitions

Changes Since V2 (kernel)
-------------------------
- Dax: Completely new fsdev driver replaces the dev_dax_iomap modifications.
  Uses MEMORY_DEVICE_FS_DAX type with order-0 folios for fs-dax compatibility.
- Dax: The "poisoned page" problem is properly fixed via fsdev_clear_folio_state()
  which clears stale mapping/compound state when fsdev binds.
- Dax: Added dax_set_ops() and driver unbind protection while filesystem mounted.
- Fuse: Famfs mounts require CAP_SYS_RAWIO (exposing raw memory devices).
- Fuse: Added DAX address_space_operations with noop_dirty_folio.
- Rebased to latest kernels, compatible with recent dax refactoring.

Testing
-------
The famfs user space [5] includes comprehensive smoke and unit tests that
exercise all three components together. The ndctl series includes a
dedicated test for famfs mode transitions.

References
----------
[1] https://lore.kernel.org/linux-cxl/cover.1708709155.git.john@groves.net/
[2] https://lore.kernel.org/linux-cxl/cover.1714409084.git.john@groves.net/
[3] https://lwn.net/Articles/983105/ (LSFMM 2024)
[4] https://lwn.net/Articles/1020170/ (LSFMM 2025)
[5] https://famfs.org (famfs user space)
[6] https://lore.kernel.org/linux-cxl/20250703185032.46568-1-john@groves.net/ (V2)

--
John Groves
