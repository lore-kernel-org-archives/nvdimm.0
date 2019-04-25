Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com
 [IPv6:2a00:1450:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C08232120B130
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 10:57:38 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id u57so690393edm.3
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 10:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <20190425152550.GY12751@dhcp22.suse.cz>
 <20190425153138.GC25193@fuggles.cambridge.arm.com>
 <20190425154156.GZ12751@dhcp22.suse.cz>
In-Reply-To: <20190425154156.GZ12751@dhcp22.suse.cz>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 25 Apr 2019 13:57:25 -0400
Message-ID: <CA+CK2bDLkSTdrYx+zth9=EJxigQR1-nMt52avt7-NpguAWwoVw@mail.gmail.com>
Subject: Re: [PATCH] arm64: configurable sparsemem section size
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, linux-mm <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Bjorn Helgaas <bhelgaas@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, sboyd@kernel.org, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, andrew.murray@arm.com, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> > I gave *vague* memories of running out of bits in the page flags if we
> > changed this, but that was a while back. If that's no longer the case,
> > then I'm open to changing the value, but I really don't want to expose
> > it as a Kconfig option as proposed in this patch. People won't have a
> > clue what to set and it doesn't help at all with the single-Image effort.
>
> Ohh, I absolutely agree about the config option part JFTR. 1GB section
> loos quite excessive. I am not really sure a standard arm64 memory
> layout looks though.

I am now looking to use Dan's patches "mm: Sub-section memory hotplug
support" to solve this problem. I think this patch can be ignored.

Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
