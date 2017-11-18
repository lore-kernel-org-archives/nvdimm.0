Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13F3220349DAC
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 22:12:54 -0800 (PST)
Date: Sat, 18 Nov 2017 14:17:03 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v4 3/4] dm-log-writes: allow DAX to be used when
 possible
Message-ID: <20171118061703.GD2749@eguan.usersys.redhat.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
 <20171117202828.25472-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171117202828.25472-4-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 01:28:27PM -0700, Ross Zwisler wrote:
> Enhance _require_dm_target so that a user can request a minimum version of a
> given dm target.
> 
> DAX support was added to v1.1.0 of the dm-log-writes kernel module, so
> allow the DAX mount option starting with that version.

Is is possible not relying on the version numbers but actually trying
what you want to do and _notrun if that fails? Currently fstests does no
version number checking at all, and it'd be great if we keep that
tradition.

Thanks,
Eryu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
