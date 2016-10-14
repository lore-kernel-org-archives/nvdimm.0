Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-Id: <5800C9740200007800117541@prv-mh.provo.novell.com>
Date: Fri, 14 Oct 2016 04:03:00 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161011194810.GD25907@localhost.localdomain>
 <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
 <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
 <57FE3B880200007800116A75@prv-mh.provo.novell.com>
 <20161012145826.wwxecoo4o3ypos5o@hz-desktop>
 <57FE75520200007800116D27@prv-mh.provo.novell.com>
 <CAPcyv4jYekNQQnD39sE=HekxUAOgXCx3_c3GLjV7MDUnvrK0vQ@mail.gmail.com>
 <57FE7A710200007800116D60@prv-mh.provo.novell.com>
 <CAPcyv4gRMhfU1MF=qYAYfidWwjjRj_qQnH6OpFsodakisP2hfQ@mail.gmail.com>
 <57FF633E0200007800116F59@prv-mh.provo.novell.com>
 <20161013085344.ulju7pnnbvufc4em@hz-desktop>
 <57FF6B130200007800116F96@prv-mh.provo.novell.com>
 <CAPcyv4hpmVU477vrAeJrcHpMS9qRSnRwY1T8FrPqAxZXMyLBOg@mail.gmail.com>
In-Reply-To: <CAPcyv4hpmVU477vrAeJrcHpMS9qRSnRwY1T8FrPqAxZXMyLBOg@mail.gmail.com>
Mime-Version: 1.0
Content-Disposition: inline
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
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, andrew.cooper3@citrix.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

>>> On 13.10.16 at 17:40, <dan.j.williams@intel.com> wrote:
> On Thu, Oct 13, 2016 at 2:08 AM, Jan Beulich <JBeulich@suse.com> wrote:
> [..]
>>> I think we can do the similar for Xen, like to lay another pseudo
>>> device on /dev/pmem and do the reservation, like 2. in my previous
>>> reply.
>>
>> Well, my opinion certainly doesn't count much here, but I continue to
>> consider this a bad idea. For entities like drivers it may well be
>> appropriate, but I think there ought to be an independent concept
>> of "OS reserved", and in the Xen case this could then be shared
>> between hypervisor and Dom0 kernel. Or if we were to consider Dom0
>> "just a guest", things should even be the other way around: Xen gets
>> all of the OS reserved space, and Dom0 needs something custom.
> 
> You haven't made the case why Xen is special and other applications of
> persistent memory are not.

Well, I'm implying this from there being a special Linux reservation.
Xen (as explained by Andrew) sitting underneath the Dom0 kernel
(other than ...

>  The current struct page reservation
> supports fundamental address-ability of persistent memory namespaces
> for the rest of the kernel.  The Xen reservation is application
> specific.  XFS, EXT4, and DM also have application specific usages of
> persistent memory and consume metadata space out of a block device. If
> we don't need an XFS-mode nvdimm device, why do we need Xen-mode?

... all the examples you give) by implication is special then too. If
you made the kernel be no different than the other examples you
give, Xen probably shouldn't be any different anymore either.

Jan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
