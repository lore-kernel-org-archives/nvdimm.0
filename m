Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-Id: <57FE3B880200007800116A75@prv-mh.provo.novell.com>
Date: Wed, 12 Oct 2016 05:32:56 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain>
 <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
 <20161011194810.GD25907@localhost.localdomain>
 <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
 <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
In-Reply-To: <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
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
To: Haozhong Zhang <haozhong.zhang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, andrew.cooper3@citrix.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

>>> On 12.10.16 at 12:33, <haozhong.zhang@intel.com> wrote:
> The layout is shown as the following diagram.
> 
> +---------------+-----------+-------+----------+--------------+
> | whatever used | Partition | Super | Reserved | /dev/pmem0p1 |
> |  by kernel    |   Table   | Block | for Xen  |              |
> +---------------+-----------+-------+----------+--------------+
>                 \_____________________ _______________________/
> 		                      V
> 				 /dev/pmem0

I have to admit that I dislike this, for not being OS-agnostic.
Neither should there be any Xen-specific region, nor should the
"whatever used by kernel" one be restricted to just Linux. What
I could see is an OS-reserved area ahead of the partition table,
the exact usage of which depends on which OS is currently
running (and in the Xen case this might be both Xen _and_ the
Dom0 kernel, arbitrated by a tbd protocol). After all, when
running under Xen, the Dom0 may not have a need for as much
control data as it has when running on bare hardware, for it
controlling less (if any) of the actual memory ranges when Xen
is present.

The assumption of course is that the reserved area holds no
persistent data. If that assumption didn't hold, you'd have to
have per-OS reserved areas anyway (as many of them as
there might be OSes [planned to get] installed on a particular
system).

Jan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
