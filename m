Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 by ml01.01.org (Postfix) with ESMTP id 2927620359E96
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 14:02:54 -0800 (PST)
Date: Mon, 4 Dec 2017 23:07:16 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 2/4] firmware: dmi: Add function to look up a handle
 and return DIMM size
Message-ID: <20171204220716.5nh4lbmbxatffd2d@pd.tnic>
References: <cover.1512070562.git.tony.luck@intel.com>
 <2fae02861e5c446c0cdd30ba3e00fad55db97807.1512070562.git.tony.luck@intel.com>
 <20171204213813.rm32qqeqchx37c5x@pd.tnic>
 <20171204220316.nl5m4lmyek7alvhb@agluck-desk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171204220316.nl5m4lmyek7alvhb@agluck-desk>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 04, 2017 at 02:03:16PM -0800, Luck, Tony wrote:
> I take it that you talked yourself out of asking for the cleanup now?

:-)

Nah, it was just a thinking-out-loud thing. Doesn't make sense to do the
cleanup, it seems.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
