Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D7F52194D3AE
 for <linux-nvdimm@lists.01.org>; Thu,  7 Feb 2019 13:52:00 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
Date: Thu, 7 Feb 2019 21:51:54 +0000
Message-ID: <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <8985FFB9EA129A48918CC8ABDA67F384@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-02-06 at 13:12 -0800, Dan Williams wrote:
> Before people get too excited this isn't a proposal to kill DAX. The
> topic proposal is a discussion to resolve lingering open questions
> that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
> current DAX facilities are enabled. The are 2 primary concerns to
> resolve. Enumerate the remaining features/fixes, and identify a path
> to implement it all without regressing any existing application use
> cases.
> 
> An enumeration of remaining projects follows, please expand this list
> if I missed something:
> 
> * "DAX" has no specific meaning by itself, users have 2 use cases for
> "DAX" capabilities: userspace cache management via MAP_SYNC, and page
> cache avoidance where the latter aspect of DAX has no current api to
> discover / use it. The project is to supplement MAP_SYNC with a
> MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
> dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
> application hint to avoid / minimiize page cache usage, but no strict
> guarantee like what MAP_SYNC provides.

Agreed that basic dax programming model needs to be settled.

> * Resolve all "if (dax) goto fail;" patterns in the kernel. Outside of
> longterm-GUP (a topic in its own right) the projects here are
> XFS-reflink and XFS-realtime-device support. DAX+reflink effectively
> requires a given physical page to be mapped into two different inodes
> at different (page->index) offsets. The challenge is to support
> DAX-reflink without violating any existing application visible
> semantics, the operating assumption / strawman to debate is that
> experimental status is not blanket permission to go change existing
> semantics in backwards incompatible ways.

I do not think "if (dax) goto fail;" is actually bad.  It helps users to
immediately realize that dax may not be enabled and they have a setup
issue.  I also think that FS-specific enhancements like DAX-reflink=1
support should be managed separately and should be possible after
EXPERIMENTAL is removed from 'mount -o dax'.  That is, removing
EXPERIMENTAL for DAX-reflink=0 should not require support of DAX-
reflink=1.

I've also had multiple users complained about 'mount -o dax' succeeded
by falling back to non-dax despite of their intent.  Such users wasted
many hours without knowing their setup error / current restrictions. 
The next think they always ask is how to check if dax is enabled in such
case, and they are not happy about limited interfaces (ex. look for
mount entry in /proc/mounts), either.

> * Deprecate, but not remove, the DAX mount option. Too many flows
> depend on the option so it will never go away, but the facility is too
> coarse. Provide an option to enable MAP_SYNC and
> more-likely-to-do-something-useful-MAP_DIRECT on a per-directory
> basis. The current proposal is to allow this property to only be
> toggled while the directory is empty to avoid the complications of
> racing page invalidation with new DAX mappings.

Same as above.  Such enhancement should be possible after EXPERIMENTAL
is removed from 'mount -o dax'.  IOW, a separate EXPERIMENTAL message
can be shown when user requests per-directory dax.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
