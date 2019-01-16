From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
Date: Wed, 16 Jan 2019 15:44:24 -0600
Message-ID: <CAErSpo6ipXF1P=tHif_ezksD_ka54LYqsc1B11Ddfksm2hp6Jg@mail.gmail.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
 <98ab9bc8-8a17-297c-da7c-2e6b5a03ef24@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <98ab9bc8-8a17-297c-da7c-2e6b5a03ef24-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jan 16, 2019 at 3:40 PM Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 1/16/19 1:16 PM, Bjorn Helgaas wrote:
> > On Wed, Jan 16, 2019 at 12:25 PM Dave Hansen
> > <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> Currently, a persistent memory region is "owned" by a device driver,
> >> either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
> >> allow applications to explicitly use persistent memory, generally
> >> by being modified to use special, new libraries.
> >
> > Is there any documentation about exactly what persistent memory is?
> > In Documentation/, I see references to pstore and pmem, which sound
> > sort of similar, but maybe not quite the same?
>
> One instance of persistent memory is nonvolatile DIMMS.  They're
> described in great detail here: Documentation/nvdimm/nvdimm.txt

Thanks!  Some bread crumbs in the changelog to lead there would be great.

Bjorn
