Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com
 [IPv6:2a00:1450:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48A122121C112
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:33:23 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id u57so17181065edm.3
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
 <CA+CK2bCD11x64pJj5gSnsu5jsUqJyU6o+=J4K8oYAsHqz9ULqQ@mail.gmail.com>
 <CA+CK2bB5ahqLrekkTUSdzTE2BPSPbB9nk6nKs+LjTap2oF8X-w@mail.gmail.com>
 <CAPcyv4gdo5GcS8cbvLQr0Ez09z32VyrbVouW2GVV5UJf8R3HWw@mail.gmail.com>
In-Reply-To: <CAPcyv4gdo5GcS8cbvLQr0Ez09z32VyrbVouW2GVV5UJf8R3HWw@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 24 Apr 2019 16:33:10 -0400
Message-ID: <CA+CK2bC7iEsg8Fdep6kphNTNroCi_zi1ejApspSZyTq_VFvxOw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, Takashi Iwai <tiwai@suse.de>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, linux-mm <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Anshuman Khandual <anshuman.khandual@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Bjorn Helgaas <bhelgaas@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, sboyd@kernel.org, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, andrew.murray@arm.com, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> This is yet another example of where we need to break down the section
> alignment requirement for arch_add_memory().
>
> https://lore.kernel.org/lkml/155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com/

Hi Dan,

Yes, that is exactly what I am trying to solve with this patch. I will
test if your series works with ARM64, and if does not I will let you
know what is broken. But, I think, this patch is not needed if your
patches are accepted into mainline.

Thank you,
Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
