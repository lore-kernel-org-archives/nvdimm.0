Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71F6520215F7B
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 02:43:52 -0700 (PDT)
Subject: Re: [Virtio-fs] [PATCH 04/19] virtio: Implement get_shm_region for
 PCI transport
References: <20190821175720.25901-1-vgoyal@redhat.com>
 <20190821175720.25901-5-vgoyal@redhat.com> <5D63392C.3030404@huawei.com>
 <20190826130607.GB3561@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D64FAD2.2050906@huawei.com>
Date: Tue, 27 Aug 2019 17:41:38 +0800
MIME-Version: 1.0
In-Reply-To: <20190826130607.GB3561@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 2019/8/26 21:06, Vivek Goyal wrote:
> On Mon, Aug 26, 2019 at 09:43:08AM +0800, piaojun wrote:
> 
> [..]
>>> +static bool vp_get_shm_region(struct virtio_device *vdev,
>>> +			      struct virtio_shm_region *region, u8 id)
>>> +{
>>> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>> +	struct pci_dev *pci_dev = vp_dev->pci_dev;
>>> +	u8 bar;
>>> +	u64 offset, len;
>>> +	phys_addr_t phys_addr;
>>> +	size_t bar_len;
>>> +	char *bar_name;
>>
>> 'char *bar_name' should be cleaned up to avoid compiling warning. And I
>> wonder if you mix tab and blankspace for code indent? Or it's just my
>> email display problem?
> 
> Will get rid of now unused bar_name. 
> 
OK

> Generally git flags if there are tab/space issues. I did not see any. So
> if you see something, point it out and I will fix it.
> 

cohuck found the same indent problem and pointed them in another email.

Jun
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
