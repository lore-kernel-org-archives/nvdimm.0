Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Oct 2016 22:58:26 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161012145826.wwxecoo4o3ypos5o@hz-desktop>
References: <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain>
 <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
 <20161011194810.GD25907@localhost.localdomain>
 <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
 <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
 <57FE3B880200007800116A75@prv-mh.provo.novell.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57FE3B880200007800116A75@prv-mh.provo.novell.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Beulich <JBeulich@suse.com>, Dan Williams <dan.j.williams@intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, andrew.cooper3@citrix.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 10/12/16 05:32 -0600, Jan Beulich wrote:
>>>> On 12.10.16 at 12:33, <haozhong.zhang@intel.com> wrote:
>> The layout is shown as the following diagram.
>>
>> +---------------+-----------+-------+----------+--------------+
>> | whatever used | Partition | Super | Reserved | /dev/pmem0p1 |
>> |  by kernel    |   Table   | Block | for Xen  |              |
>> +---------------+-----------+-------+----------+--------------+
>>                 \_____________________ _______________________/
>> 		                      V
>> 				 /dev/pmem0
>
>I have to admit that I dislike this, for not being OS-agnostic.
>Neither should there be any Xen-specific region, nor should the
>"whatever used by kernel" one be restricted to just Linux. What
>I could see is an OS-reserved area ahead of the partition table,
>the exact usage of which depends on which OS is currently
>running (and in the Xen case this might be both Xen _and_ the
>Dom0 kernel, arbitrated by a tbd protocol). After all, when
>running under Xen, the Dom0 may not have a need for as much
>control data as it has when running on bare hardware, for it
>controlling less (if any) of the actual memory ranges when Xen
>is present.
>

Isn't this OS-reserved area still not OS-agnostic, as it requires OS
to know where the reserved area is?  Or do you mean it's not if it's
defined by a protocol that is accepted by all OSes?

Let me list another two methods just coming to my mind.

1. The first method extends the usage of the super block used by
   current Linux kernel to reserve space on pmem.

   Current Linux kernel places a super block of the following
   structure near the beginning of a pmem namespace.

    struct nd_pfn_sb {
            u8 signature[PFN_SIG_LEN];
            u8 uuid[16];
            u8 parent_uuid[16];
            __le32 flags;
            __le16 version_major;
            __le16 version_minor;
            __le64 dataoff; /* relative to namespace_base + start_pad */
            __le64 npfns;
            __le32 mode;
            /* minor-version-1 additions for section alignment */
            __le32 start_pad;
            __le32 end_trunc;
            /* minor-version-2 record the base alignment of the mapping */
            __le32 align;
            u8 padding[4000];
            __le64 checksum;
    }

    Two interesting fields here are 'dataoff' and 'mode':
    - 'dataoff' indicates the offset where the data area starts,
      ie. IIUC, the part that can be accessed via /dev/pmemN or
      /dev/daxN.
    - 'mode' indicates whether Linux puts struct page for this
      namespace in the ram (= PFN_MODE_RAM) or on the device (=
      PFN_MODE_PMEM).

    Currently for Linux, only 'mode' is customizable, while 'dataoff'
    is not. If mode == PFN_MODE_RAM, no reservation for struct page is
    made on the device, and dataoff starts almost immediately after
    the super block except a small reserved area in between for other
    structures and alignment. If mode == PFN_MODE_PMEM, the size of
    the reservation is decided by kernel, i.e. 64 bytes per struct
    page.

    I propose to make the size of the reserved area customizable,
    e.g. via ioctl and ndctl.
    - If mode == PFN_MODE_PMEM and
      * if the given reserved size is large enough to hold what an OS
        (not limited to Linux) wants to put in, then the OS just
        starts use it as desired;
      * if the given reserved size is not enough, then the OS reports
        error and may take other fallback actions.
    - If mode == PFN_MODE_RAM and
      * if the reserved size is zero, then it's the current way that
        Linux uses the device;
      * if the reserved size is non-zero, I would like to reserve this
        case for hypervisor (right now, namely Xen hypervisor)
        usage. That is, the OS should not use the reserved area. For
        Xen, we could add a function in xen driver in kernel to report
        the reserved area to hypervisor.

   I guess this might be the OS-agnostic way Jan expects, but Dan may
   object to.


2. Lay another pseudo device on the block device (e.g. /dev/pmemN)
   provided by the NVDIMM driver.

   This pseudo device can reserve the size according to user's
   requirement. The reservation information can be persistently
   recorded in a super block before the reserved area.

   This pseudo device also implements another pseudo block device to
   allow the non-reserved area be accessed as a block device (we can
   even implement it as DAX-capable).

                                               pseudo block device
                                             /---------^-----------\
+------------------+-------+---------------+-----------------------+
|  whatever used   | Super |  reserved by  |                       |
| by NVDIMM driver | Block | pseudo device |                       |
+------------------+-------+---------------+-----------------------+
                     \_____________________ _______________________/
                                           V
                                       /dev/pmem0
                                (provided by NVDIMM driver)

   In order to make it work across difference OSes, it requires other
   OS recognizes the same types of pmem block devices made by Linux,
   and implements the driver for the pseudo device.

   This is inspired by Dan's reply at
   https://lists.xenproject.org/archives/html/xen-devel/2016-10/msg00651.html.

   However, it's essentially the same as my partition solution, so I guess
   Jan will still dislike.


Any comments?

>The assumption of course is that the reserved area holds no
>persistent data. If that assumption didn't hold, you'd have to
>have per-OS reserved areas anyway (as many of them as
>there might be OSes [planned to get] installed on a particular
>system).
>

No persistent data should be placed in the reserved area.

Thanks,
Haozhong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
