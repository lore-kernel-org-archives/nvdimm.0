Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x242.google.com (mail-lf0-x242.google.com
 [IPv6:2a00:1450:4010:c07::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1F4322436945
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 08:50:07 -0800 (PST)
Received: by mail-lf0-x242.google.com with SMTP id f75so8251979lfg.6
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 08:56:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180223085547.3kkbo5lbt3orkqqn@hz-desktop>
References: <151937026001.18973.12034171121582300402.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180223085547.3kkbo5lbt3orkqqn@hz-desktop>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Feb 2018 08:56:06 -0800
Message-ID: <CAPcyv4hmzhY6paR+AayNMmbdM3Fg2Rg2dKwH7NoYAQA25GcgSg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] vfio, dax: prevent long term filesystem-dax pins
 and other fixes
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kbuild test robot <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 23, 2018 at 12:55 AM, Haozhong Zhang
<haozhong.zhang@intel.com> wrote:
> On 02/22/18 23:17 -0800, Dan Williams wrote:
>> Changes since v1 [1]:
>>
>> * Fix the detection of device-dax file instances in vma_is_fsdax().
>>   (Haozhong, Gerd)
>>
>> * Fix compile breakage in the FS_DAX=n and DEV_DAX=y case. (0day robot)
>>
>> [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-February/014046.html
>>
>> ---
>>
>> The vfio interface, like RDMA, wants to setup long term (indefinite)
>> pins of the pages backing an address range so that a guest or userspace
>> driver can perform DMA to the with physical address. Given that this
>> pinning may lead to filesystem operations deadlocking in the
>> filesystem-dax case, the pinning request needs to be rejected.
>>
>> The longer term fix for vfio, RDMA, and any other long term pin user, is
>> to provide a 'pin with lease' mechanism. Similar to the leases that are
>> hold for pNFS RDMA layouts, this userspace lease gives the kernel a way
>> to notify userspace that the block layout of the file is changing and
>> the kernel is revoking access to pinned pages.
>>
>> ---
>>
>> Dan Williams (5):
>>       dax: fix vma_is_fsdax() helper
>>       dax: fix dax_mapping() definition in the FS_DAX=n + DEV_DAX=y case
>>       dax: fix S_DAX definition
>>       dax: short circuit vma_is_fsdax() in the CONFIG_FS_DAX=n case
>>       vfio: disable filesystem-dax page pinning
>>
>>
>>  drivers/vfio/vfio_iommu_type1.c |   18 +++++++++++++++---
>>  include/linux/dax.h             |    9 ++++++---
>>  include/linux/fs.h              |    6 ++++--
>>  3 files changed, 25 insertions(+), 8 deletions(-)
>
> Tested on QEMU with fs-dax and device-dax as vNVDIMM backends
> respectively with vfio passthrough. The fs-dax case fails QEMU as
> expected, and the device-dax case works normally now.
>
> Tested-by: Haozhong Zhang <haozhong.zhang@intel.com>
>

Thank you!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
