Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 26 Apr 2019 07:33:35 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] arm64: configurable sparsemem section size
Message-ID: <20190426053335.GD12337@dhcp22.suse.cz>
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <20190425152550.GY12751@dhcp22.suse.cz>
 <20190425153138.GC25193@fuggles.cambridge.arm.com>
 <20190425154156.GZ12751@dhcp22.suse.cz>
 <CA+CK2bDLkSTdrYx+zth9=EJxigQR1-nMt52avt7-NpguAWwoVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bDLkSTdrYx+zth9=EJxigQR1-nMt52avt7-NpguAWwoVw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Will Deacon <will.deacon@arm.com>, James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, rppt@linux.vnet.ibm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, andrew.murray@arm.com, james.morse@arm.com, Marc Zyngier <marc.zyngier@arm.com>, sboyd@kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 25-04-19 13:57:25, Pavel Tatashin wrote:
> > > I gave *vague* memories of running out of bits in the page flags if we
> > > changed this, but that was a while back. If that's no longer the case,
> > > then I'm open to changing the value, but I really don't want to expose
> > > it as a Kconfig option as proposed in this patch. People won't have a
> > > clue what to set and it doesn't help at all with the single-Image effort.
> >
> > Ohh, I absolutely agree about the config option part JFTR. 1GB section
> > loos quite excessive. I am not really sure a standard arm64 memory
> > layout looks though.
> 
> I am now looking to use Dan's patches "mm: Sub-section memory hotplug
> support" to solve this problem. I think this patch can be ignored.

Even if the subsection memory hotplug is going to be used then the
underlying question remains. If there is no real reason to use large
memsections then it would be better to use smaller ones.
-- 
Michal Hocko
SUSE Labs
