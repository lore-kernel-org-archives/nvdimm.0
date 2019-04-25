Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id B622021217961
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 08:31:46 -0700 (PDT)
Date: Thu, 25 Apr 2019 16:31:38 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: configurable sparsemem section size
Message-ID: <20190425153138.GC25193@fuggles.cambridge.arm.com>
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <20190425152550.GY12751@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190425152550.GY12751@dhcp22.suse.cz>
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
Cc: tiwai@suse.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, linux-mm@kvack.org, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, sashal@kernel.org, linux-nvdimm@lists.01.org, jmorris@namei.org, ying.huang@intel.com, bp@suse.de, thomas.lendacky@amd.com, Pavel Tatashin <pasha.tatashin@soleen.com>, marc.zyngier@arm.com, jglisse@redhat.com, rppt@linux.vnet.ibm.com, bhelgaas@google.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, sboyd@kernel.org, linux-kernel@vger.kernel.org, james.morse@arm.com, andrew.murray@arm.com, akpm@linux-foundation.org, fengguang.wu@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 25, 2019 at 05:25:50PM +0200, Michal Hocko wrote:
> On Tue 23-04-19 16:38:43, Pavel Tatashin wrote:
> > sparsemem section size determines the maximum size and alignment that
> > is allowed to offline/online memory block. The bigger the size the less
> > the clutter in /sys/devices/system/memory/*. On the other hand, however,
> > there is less flexability in what granules of memory can be added and
> > removed.
> > 
> > Recently, it was enabled in Linux to hotadd persistent memory that
> > can be either real NV device, or reserved from regular System RAM
> > and has identity of devdax.
> > 
> > The problem is that because ARM64's section size is 1G, and devdax must
> > have 2M label section, the first 1G is always missed when device is
> > attached, because it is not 1G aligned.
> > 
> > Allow, better flexibility by making section size configurable.
> 
> Is there any inherent reason (64k page size?) that enforces such a large
> memsection?

I gave *vague* memories of running out of bits in the page flags if we
changed this, but that was a while back. If that's no longer the case,
then I'm open to changing the value, but I really don't want to expose
it as a Kconfig option as proposed in this patch. People won't have a
clue what to set and it doesn't help at all with the single-Image effort.

Will
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
