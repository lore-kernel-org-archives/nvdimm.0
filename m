Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4535D211799F4
 for <linux-nvdimm@lists.01.org>; Sat, 27 Oct 2018 04:00:06 -0700 (PDT)
Date: Sat, 27 Oct 2018 19:00:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
Message-ID: <20181027110003.5opfjr7q36rhumah@wfg-t540p.sh.intel.com>
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181022201317.8558C1D8@viggo.jf.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, zwisler@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

What's the base tree for this patchset? I tried 4.19, linux-next and
Dan's libnvdimm-for-next branch, but none applies cleanly.

Thanks,
Fengguang
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
