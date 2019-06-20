Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C62A72194EB78
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 06:42:16 -0700 (PDT)
Date: Thu, 20 Jun 2019 09:42:13 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1924997913.36339287.1561038133965.JavaMail.zimbra@redhat.com>
In-Reply-To: <201906201741.FD4FeYGb%lkp@intel.com>
References: <201906201741.FD4FeYGb%lkp@intel.com>
Subject: Re: [linux-nvdimm:libnvdimm-for-next 4/15]
 drivers/nvdimm/virtio_pmem.c:61:9: sparse: sparse: incompatible types in
 comparison expression (different base types):
MIME-Version: 1.0
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
To: kbuild test robot <lkp@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-nvdimm@lists.01.org, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi,

Thanks for the email. I will fix this warning with other build fixes found
by test bot and send a v14.

Best regards,
Pankaj

> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> libnvdimm-for-next
> head:   3b6047778c09037615e7b919c922081ef1a37a7f
> commit: 5990fce9c50eae1261a52df1488d04a47f4cfca7 [4/15] virtio-pmem: Add
> virtio pmem driver
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
>         git checkout 5990fce9c50eae1261a52df1488d04a47f4cfca7
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/nvdimm/virtio_pmem.c:61:9: sparse: sparse: incompatible types in
> >> comparison expression (different base types):
> >> drivers/nvdimm/virtio_pmem.c:61:9: sparse:    restricted __le64 *
> >> drivers/nvdimm/virtio_pmem.c:61:9: sparse:    unsigned long long *
>    drivers/nvdimm/virtio_pmem.c:63:9: sparse: sparse: incompatible types in
>    comparison expression (different base types):
>    drivers/nvdimm/virtio_pmem.c:63:9: sparse:    restricted __le64 *
>    drivers/nvdimm/virtio_pmem.c:63:9: sparse:    unsigned long long *
> 
> vim +61 drivers/nvdimm/virtio_pmem.c
> 
>     31
>     32	static int virtio_pmem_probe(struct virtio_device *vdev)
>     33	{
>     34		struct nd_region_desc ndr_desc = {};
>     35		int nid = dev_to_node(&vdev->dev);
>     36		struct nd_region *nd_region;
>     37		struct virtio_pmem *vpmem;
>     38		struct resource res;
>     39		int err = 0;
>     40
>     41		if (!vdev->config->get) {
>     42			dev_err(&vdev->dev, "%s failure: config access disabled\n",
>     43				__func__);
>     44			return -EINVAL;
>     45		}
>     46
>     47		vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem), GFP_KERNEL);
>     48		if (!vpmem) {
>     49			err = -ENOMEM;
>     50			goto out_err;
>     51		}
>     52
>     53		vpmem->vdev = vdev;
>     54		vdev->priv = vpmem;
>     55		err = init_vq(vpmem);
>     56		if (err) {
>     57			dev_err(&vdev->dev, "failed to initialize virtio pmem vq's\n");
>     58			goto out_err;
>     59		}
>     60
>   > 61		virtio_cread(vpmem->vdev, struct virtio_pmem_config,
>     62				start, &vpmem->start);
>     63		virtio_cread(vpmem->vdev, struct virtio_pmem_config,
>     64				size, &vpmem->size);
>     65
>     66		res.start = vpmem->start;
>     67		res.end   = vpmem->start + vpmem->size - 1;
>     68		vpmem->nd_desc.provider_name = "virtio-pmem";
>     69		vpmem->nd_desc.module = THIS_MODULE;
>     70
>     71		vpmem->nvdimm_bus = nvdimm_bus_register(&vdev->dev,
>     72							&vpmem->nd_desc);
>     73		if (!vpmem->nvdimm_bus) {
>     74			dev_err(&vdev->dev, "failed to register device with nvdimm_bus\n");
>     75			err = -ENXIO;
>     76			goto out_vq;
>     77		}
>     78
>     79		dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
>     80
>     81		ndr_desc.res = &res;
>     82		ndr_desc.numa_node = nid;
>     83		ndr_desc.flush = async_pmem_flush;
>     84		set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>     85		set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
>     86		nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
>     87		if (!nd_region) {
>     88			dev_err(&vdev->dev, "failed to create nvdimm region\n");
>     89			err = -ENXIO;
>     90			goto out_nd;
>     91		}
>     92		nd_region->provider_data =
>     dev_to_virtio(nd_region->dev.parent->parent);
>     93		return 0;
>     94	out_nd:
>     95		nvdimm_bus_unregister(vpmem->nvdimm_bus);
>     96	out_vq:
>     97		vdev->config->del_vqs(vdev);
>     98	out_err:
>     99		return err;
>    100	}
>    101
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
