Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20161011183259.GA23193@localhost.localdomain>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Oct 2016 12:28:56 -0700
Message-ID: <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
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
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Jan Beulich <jbeulich@suse.com>, andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 11:33 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Oct 11, 2016 at 10:51:19AM -0700, Dan Williams wrote:
[..]
>> Right, but why does the libnvdimm core need to know about this
>> specific Xen reservation?  For example, if Xen wants some in-kernel
>
> Let me turn this around - why does the libnvdimm core need to know about
> Linux specific parts? Shouldn't this be OS agnostic, so that FreeBSD
> for example can also poke a hole in this and fill it with its
> OS-management meta-data?

Specifically the core needs to know so that it can answer the Linux
specific question of whether the pfn returned by ->direct_access() has
a corresponding struct page or not. It's tied to the lifetime of the
device and the usage of the reservation needs to be coordinated
against the references of those pages.  If FreeBSD decides it needs to
reserve "struct page" capacity at the start of the device, I would
hope that it reuses the same on-device info block that Linux is using
and not create a new "FreeBSD-mode" device type.

To be honest I do not yet understand what metadata Xen wants to store
in the device, but it seems the producer and consumer of that metadata
is Xen itself and not the wider Linux kernel as is the case with
struct page.  Can you fill me in on what problem Xen solves with this
reservation?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
