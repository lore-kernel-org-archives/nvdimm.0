Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41B7C1A1EFA
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:48:29 -0800 (PST)
Date: Thu, 10 Mar 2016 20:48:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] mm: Remove VM_FAULT_MINOR
Message-ID: <20160310194834.GA21368@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-4-git-send-email-jack@suse.cz>
 <100D68C7BA14664A8938383216E40DE0422079B3@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE0422079B3@FMSMSX114.amr.corp.intel.com>
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
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NeilBrown <neilb@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 10-03-16 19:38:56, Wilcox, Matthew R wrote:
> You've clearly fixed a bug in xtensa here ;-)  Wonder why nobody noticed
> that counter was always 0?

Likely that architecture is not used too much ;). BTW, I forgot to mention
that patch 4 has been already been merged into Linus' tree today and this
patch is sitting in mm tree. They are unrelated and I was just lazy to
remove them from the series at this point.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
