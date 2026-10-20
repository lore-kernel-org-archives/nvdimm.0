Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515051;
	b=OfyyjySUwnFj4rSeMrG1NoI93MNvktc2ga+ogskK6r4lqTFLt+pKlnmUwg6GQT0nEBMM
	 wDGTUtwuPYWuTDCXSkdcOAK99XpV+mUny0Lg65nvFGIgZx/GKU9EXmxHD8u2m2UUlIFoi
	 7QDP3+gxLOw3yXWf6fks7cWbQ8+vr57F0ja8A3EKn0o5Y4gbfz/uGbHDJA8Yu75ZYkbu8
	 cT1yM+3wya+FnjCYhofx2+thov8ZTcOLEAKArdC/CzwxuxTMAMbWEiZis/e5l3OGvsjUz
	 yvUs30+Qb9z0QNkS9VF0wnc39WgxEENmK0CH9PkGya7f3ChY53uPBav8jBPeWIg4MPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515051;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:X-HE-Tag:X-HE-Meta;
	bh=PnmvAioouzOwQoC09Cdmt1tpBbxHXn0G8J4x1674Zv4=;
	b=px9N7GcsyyPb+n+98vCDuURkdFUrWl9X0vTOSjqc8SMVf7qCbTEOnHhIJmxBdJoXwDvo
	 qzmlEngKwbJV34vslrA2Bv2mMo8Uq2QSNGOlJIOI72D1Dy6dClS3inh7L8UG/86KDGlCc
	 NtpGMSh7htKP+WBrnheYmBuBp3Uqxnsn6nEzIrn1b3SueDgeWM3dSLpmPZ4X3bLbXzDPk
	 jdjOsOmK2ZtqXEuXalS8I1Y8pnwB7ZETJKPJJZMUGIr6nZywk/tOH1nbRqJLyDkLLAZtw
	 mQLig2kh/fSqUQ3i5zbfpIVlSBKg4+Ey3yPlbhmoG3Jp3LryJaviTwf37TmHpJv+cOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=groves.net;
	spf=pass smtp.mailfrom=groves.net;
	arc=none smtp.remote-ip=216.40.44.15
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300A860A2630;
	Tue, 20 Oct 2026 16:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 300A860A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48BCD80110;
	Tue, 20 Oct 2026 16:50:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf07.hostedemail.com (Postfix) with ESMTPA id 027852002C;
	Tue, 20 Oct 2026 16:50:46 +0000 (UTC)
Date: Tue, 20 Oct 2026 11:50:45 -0500
From: John Groves <john@groves.net>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v5 00/10] fuse: DAX device based extent maps (famfs)
Message-ID: <atebTqE6E7qrEmqI@groves.net>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016151638.2962413-1-mszeredi@redhat.com>
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 027852002C
X-Stat-Signature: ryu1ic3iufidkbatut4ng4go3zkhny4h
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19iLIuEpncD+kVsCkM1rZtglGsU8PhfIBc=
X-HE-Tag: 1792515046-62564
X-HE-Meta: U2FsdGVkX1/zQocfxwA9/b8bi2d+5RkHAHVE6Os6e2LjiNkInITgGXoZEe/6J2a6vqfWw4TbOlVsAfSLvfQmZXXzVrfgX2Qcbh0EvVXlLdVh0/2FE9MyWzx7J2o1UBrAeEvsHQWVAvZ9uQLHmGQzjDDhFrU+eT5NrNTb9ecro8um6vfr7f6wkKt2xbuE030FDcCRJ+G7n3LsxYOgqJmC87G3Ow5xo8q1RzFvcTkI0yFzX0V67CYHf3r3poexxE7o5eW8p7N4Q5xrEpfSGAwQ4q1U2S6sk561wiw9rAGczxocB+OhyaZmMDk5wl+RWzN4/ikjwePSGssdf0gj+bBlFP9ToYTNwhqL1lptx07tY3qskVDQEjq+yxbF1aZSUSBxKAjx4LEfrXs8AwDV9R1sFTQp8aIODveQe+nS4F1kckw=

On 26/10/16 05:16PM, Miklos Szeredi wrote:
> This is the FUSIfication of the famfs-fuse patchset.
> 
>  - extent maps are assigned to a backing ID
> 
>  - 64 bit backing ID's managed by server
> 
>  - maps can be linear or cyclic (striped)
> 
>  - API supports nesting, but not implemented yet (i.e. multiple striped
>    extents per inode, a-la famfs)
> 
> libfuse/famfs trees for testing:
> 
>  https://github.com/szmi/libfuse.git#extent-map-v3
>  https://github.com/jagalactic/famfs.git#master
> 
> This patchset:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#for-next
> 
> Passes famfs smoke test on emulated dax device.
> 
> Comments are welcome.
> 
> Thanks,
> Miklos
> 
> ---
> Changes since v4:
> 
>  - extent array (John)
>  - error out on truncate/hole punch on a dax backed file (Sashiko)
>  - small fix (Sashiko)
> 
> Changes since v3:
> 
>  - redid the first patch (prompted by sashiko: passing dev_t is racy)
>  - more fixes (John, Amir Sashiko)
> 
> Changes since v2:
> 
>  - add a trivial prep patch modifying drivers/dax/super.c
>  - reserve zero value for 64 bit backing ID (Amir)
>  - add Originally-by: tag to acknowledge John's work
>  - more fixes and cleanups (Amir, Sashiko)
> 
> Changes since v1:
> 
>  - moved 3 prep patches to fuse.git#for-next
>  - introduce FUSE_PASSTHROUGH_V2 (Amir)
>  - lots of small fixes and cleanups (Amir, Sashiko)
> 
> ---
> John Groves (2):
>   dax: add fsdev_dax_from_file()
>   fuse: resolve extent maps in O(1) when possible
> 
> Miklos Szeredi (8):
>   dax: use READ_ONCE() in dax_holder()
>   fuse: add helpers for EIO return value with kernel message
>   fuse: support 64 bit, server allocated backing ID
>   fuse: support opening 64 bit backing ID
>   fuse: add support for opening dax device as backing
>   fuse: add extent map data structure
>   fuse: add extent map I/O support
>   fuse: add support for striped backing
> 
>  drivers/dax/fsdev.c       |  23 +++
>  drivers/dax/super.c       |   5 +-
>  fs/file.c                 |   1 +
>  fs/fuse/Makefile          |   2 +-
>  fs/fuse/backing.c         | 302 ++++++++++++++++++++++++------
>  fs/fuse/dev.c             |  54 ++++--
>  fs/fuse/dev.h             |   3 +
>  fs/fuse/dir.c             |   6 +-
>  fs/fuse/ext_map.c         | 376 ++++++++++++++++++++++++++++++++++++++
>  fs/fuse/file.c            |  33 +++-
>  fs/fuse/fuse_i.h          |  79 +++++++-
>  fs/fuse/inode.c           |  25 ++-
>  fs/fuse/iomode.c          | 116 ++++++------
>  fs/fuse/notify.c          |  75 ++++++++
>  fs/fuse/passthrough.c     |  66 +++----
>  include/linux/dax.h       |   3 +-
>  include/uapi/linux/fuse.h |  53 +++++-
>  17 files changed, 1044 insertions(+), 178 deletions(-)
>  create mode 100644 fs/fuse/ext_map.c
> 
> -- 
> 2.54.0
> 

For the series:

Reviewed-by: John Groves <john@groves.net>
Tested-by: John Groves <john@groves.net>


