Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BCD126BF1
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883659; cv=none; b=E7nOKSbH55ov13jcQeHK+RrXjmPLq817qoolwLrB2FEhr9FdiS4kgsMAY0fNCRdM2Tof2ECCCAKZl0wZaULep9c4OpW6RxwfvufASOL0c/etcszuy/ymImZlBMVRNkeYhLvhxYIDXt9Ya6Ja7zf8oXWvYUBr5bGcWIbU1btGrco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883659; c=relaxed/simple;
	bh=xfUMr00GiQWqarGlK84n+X7c2/D54ntaL99qPp1/WOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s6+Ij55H9NSDDyNwX+qY6k7owlBSei4jBRvW1KlThYX1bCtfTXBMHagEUxSnl2dklVydYFBWAUNPMEf70ffFs6k1NfyreYvh5DkCs0F3no1dXWBZ96RnLTZ4dBTgZybO96k2Cm/Tio4yuTRzIqFQ7NLW2wY3bAl3Le9DmZ22Pgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72B9289AEB;
	Thu, 19 Mar 2026 01:27:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf18.hostedemail.com (Postfix) with ESMTPA id 8E9FE38;
	Thu, 19 Mar 2026 01:27:23 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
Subject: [PATCH BUNDLE v8] famfs: Fabric-Attached Memory File System
Date: Wed, 18 Mar 2026 20:27:22 -0500
Message-ID: <20260318202722.4344.compound@groves.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 8E9FE38
X-Stat-Signature: pqtgznszo6d3sh9zp6zfujni1kn5mw1n
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+KSkfMLtkhOCAMr7mIroRj3CddNMrTBu0=
X-HE-Tag: 1773883643-198796
X-HE-Meta: U2FsdGVkX1+HeuNtEKK9Ssz90FztUmcy4MiIx7M/ocf+BrDpOPP8BeqHo8/S3y9Nbcm1PUFYaB5K1KxbVcMlB/uKyMhr93qXwfNml4+QHBhAVwrdY9cENdFUBy1o6NLS+/rkWa25KvcjqvcOWKCGfikcUCt3fpWAC/0PHeP3o+i6BrVFJn+VobkA/V7Fu5feXoAKqgmQkcdHPpZJFB4TRNAXPuK0M3cedqw+WWPgmHsRkin0ZGRLdQKZHtpNCfo2P3ItnCVIjW354d9EPz791GTVyf6Hx1vSsgZB8vD7hMyxzSJtw4Ngn2Ub6oMMHiCMzS7SCxmA6NZyVdxMtYFdcQHt+FFm8m+edVNaoaYUqAoidUgk9pNiv6DigK1mRMOkV58M4bkHEerNeDfueYHVSj043doakafAqJ3qp3fdC85ElISVBHJX4sDfaQX7nBnBrNOhbdKVbMCDeEasaNb5C1JBOyyoDjSz

This is a coordinated patch submission for famfs (Fabric-Attached Memory
File System) across three repositories:

  1. Linux kernel dax (cover + 7 patches) - dax fsdev driver + fuse/famfs 
     integration
  2. Linux kernel fs/fuse - famfs support into fuse. Depends on the dax
     patches

This bundle does not contain the user space libfuse and ndctl patches;
those will be sent separately to the respective projects.

Note: in this version I split the kernel dax patches into a separate
series from the kernel fuse patches. This is because those go through
separate maintainers. The plan is for the dax patches to go into Ira's
dax tree, and for Miklos to pull in that branch and apply the fuse series
on top if it.

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

Linux Kernel dax (V8, xx patches): New fsdev driver (drivers/dax/fsdev.c)
providing a devdax mode compatible with fs-dax. Devices can be switched
among 'devdax', 'fsdev' and 'system-ram' modes via daxctl or sysfs.


Linux kernel fuse (V8, xx patches: Famfs integration adding GET_FMAP and
GET_DAXDEV messages for caching file-to-dax mappings in the kernel.

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
[7] https://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-john@groves.net/T/#m0000d8c00290f48c086b8b176c7525e410f8508c (related ndctl series)
--
John Groves
