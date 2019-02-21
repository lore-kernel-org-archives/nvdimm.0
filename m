Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA7DA2095DFF1
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 09:09:31 -0800 (PST)
Date: Thu, 21 Feb 2019 18:09:21 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 1/2] nfit, mce: only handle uncorrectable machine checks
Message-ID: <20190221170921.GC12997@zn.tnic>
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <x49lg2a2sn0.fsf@segfault.boston.devel.redhat.com>
 <20190220191852.GF3447@zn.tnic>
 <x49d0nm2rd6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hNq8TPVkrNwqZJHyfSg+JUHG6taS5pz0r6+xAa29NTag@mail.gmail.com>
 <x49y369ruj4.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49y369ruj4.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 21, 2019 at 11:11:27AM -0500, Jeff Moyer wrote:
> Anyway, given that the correctable errors collector can be turned off in
> the kernel config,

Also, on the cmdline, for whatever reason:

ras=cec_disable

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
