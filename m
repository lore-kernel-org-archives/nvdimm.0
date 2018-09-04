From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3]  virtio-pmem: Add virtio pmem driver
Date: Tue, 4 Sep 2018 23:17:00 +0800
Message-ID: <20180904151700.GH17047@intel.com>
References: <20180831133019.27579-4-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180831133019.27579-4-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi Pankaj,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v4.19-rc2 next-20180903]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Pankaj-Gupta/kvm-fake-DAX-device/20180903-160032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: i386-randconfig-a3-201835 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 
:::::: branch date: 21 hours ago
:::::: commit date: 21 hours ago

All errors (new ones prefixed by >>):

   drivers/virtio/virtio_pmem.o: In function `virtio_pmem_remove':
>> drivers/virtio/virtio_pmem.c:220: undefined reference to `nvdimm_bus_unregister'
   drivers/virtio/virtio_pmem.o: In function `virtio_pmem_probe':
>> drivers/virtio/virtio_pmem.c:186: undefined reference to `nvdimm_bus_register'
>> drivers/virtio/virtio_pmem.c:198: undefined reference to `nvdimm_pmem_region_create'
   drivers/virtio/virtio_pmem.c:207: undefined reference to `nvdimm_bus_unregister'

# https://github.com/0day-ci/linux/commit/acce2633da18b0ad58d0cc9243a85b03020ca099
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout acce2633da18b0ad58d0cc9243a85b03020ca099
vim +220 drivers/virtio/virtio_pmem.c

acce2633 Pankaj Gupta 2018-08-31  147  
acce2633 Pankaj Gupta 2018-08-31  148  static int virtio_pmem_probe(struct virtio_device *vdev)
acce2633 Pankaj Gupta 2018-08-31  149  {
acce2633 Pankaj Gupta 2018-08-31  150  	int err = 0;
acce2633 Pankaj Gupta 2018-08-31  151  	struct resource res;
acce2633 Pankaj Gupta 2018-08-31  152  	struct virtio_pmem *vpmem;
acce2633 Pankaj Gupta 2018-08-31  153  	struct nvdimm_bus *nvdimm_bus;
acce2633 Pankaj Gupta 2018-08-31  154  	struct nd_region_desc ndr_desc;
acce2633 Pankaj Gupta 2018-08-31  155  	int nid = dev_to_node(&vdev->dev);
acce2633 Pankaj Gupta 2018-08-31  156  	struct nd_region *nd_region;
acce2633 Pankaj Gupta 2018-08-31  157  
acce2633 Pankaj Gupta 2018-08-31  158  	if (!vdev->config->get) {
acce2633 Pankaj Gupta 2018-08-31  159  		dev_err(&vdev->dev, "%s failure: config disabled\n",
acce2633 Pankaj Gupta 2018-08-31  160  			__func__);
acce2633 Pankaj Gupta 2018-08-31  161  		return -EINVAL;
acce2633 Pankaj Gupta 2018-08-31  162  	}
acce2633 Pankaj Gupta 2018-08-31  163  
acce2633 Pankaj Gupta 2018-08-31  164  	vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
acce2633 Pankaj Gupta 2018-08-31  165  			GFP_KERNEL);
acce2633 Pankaj Gupta 2018-08-31  166  	if (!vpmem) {
acce2633 Pankaj Gupta 2018-08-31  167  		err = -ENOMEM;
acce2633 Pankaj Gupta 2018-08-31  168  		goto out_err;
acce2633 Pankaj Gupta 2018-08-31  169  	}
acce2633 Pankaj Gupta 2018-08-31  170  
acce2633 Pankaj Gupta 2018-08-31  171  	vpmem->vdev = vdev;
acce2633 Pankaj Gupta 2018-08-31  172  	err = init_vq(vpmem);
acce2633 Pankaj Gupta 2018-08-31  173  	if (err)
acce2633 Pankaj Gupta 2018-08-31  174  		goto out_err;
acce2633 Pankaj Gupta 2018-08-31  175  
acce2633 Pankaj Gupta 2018-08-31  176  	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
acce2633 Pankaj Gupta 2018-08-31  177  			start, &vpmem->start);
acce2633 Pankaj Gupta 2018-08-31  178  	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
acce2633 Pankaj Gupta 2018-08-31  179  			size, &vpmem->size);
acce2633 Pankaj Gupta 2018-08-31  180  
acce2633 Pankaj Gupta 2018-08-31  181  	res.start = vpmem->start;
acce2633 Pankaj Gupta 2018-08-31  182  	res.end   = vpmem->start + vpmem->size-1;
acce2633 Pankaj Gupta 2018-08-31  183  	vpmem->nd_desc.provider_name = "virtio-pmem";
acce2633 Pankaj Gupta 2018-08-31  184  	vpmem->nd_desc.module = THIS_MODULE;
acce2633 Pankaj Gupta 2018-08-31  185  
acce2633 Pankaj Gupta 2018-08-31 @186  	vpmem->nvdimm_bus = nvdimm_bus = nvdimm_bus_register(&vdev->dev,
acce2633 Pankaj Gupta 2018-08-31  187  						&vpmem->nd_desc);
acce2633 Pankaj Gupta 2018-08-31  188  	if (!nvdimm_bus)
acce2633 Pankaj Gupta 2018-08-31  189  		goto out_vq;
acce2633 Pankaj Gupta 2018-08-31  190  
acce2633 Pankaj Gupta 2018-08-31  191  	dev_set_drvdata(&vdev->dev, nvdimm_bus);
acce2633 Pankaj Gupta 2018-08-31  192  	memset(&ndr_desc, 0, sizeof(ndr_desc));
acce2633 Pankaj Gupta 2018-08-31  193  
acce2633 Pankaj Gupta 2018-08-31  194  	ndr_desc.res = &res;
acce2633 Pankaj Gupta 2018-08-31  195  	ndr_desc.numa_node = nid;
acce2633 Pankaj Gupta 2018-08-31  196  	ndr_desc.flush = virtio_pmem_flush;
acce2633 Pankaj Gupta 2018-08-31  197  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
acce2633 Pankaj Gupta 2018-08-31 @198  	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
acce2633 Pankaj Gupta 2018-08-31  199  
acce2633 Pankaj Gupta 2018-08-31  200  	if (!nd_region)
acce2633 Pankaj Gupta 2018-08-31  201  		goto out_nd;
acce2633 Pankaj Gupta 2018-08-31  202  
acce2633 Pankaj Gupta 2018-08-31  203  	//virtio_device_ready(vdev);
acce2633 Pankaj Gupta 2018-08-31  204  	return 0;
acce2633 Pankaj Gupta 2018-08-31  205  out_nd:
acce2633 Pankaj Gupta 2018-08-31  206  	err = -ENXIO;
acce2633 Pankaj Gupta 2018-08-31  207  	nvdimm_bus_unregister(nvdimm_bus);
acce2633 Pankaj Gupta 2018-08-31  208  out_vq:
acce2633 Pankaj Gupta 2018-08-31  209  	vdev->config->del_vqs(vdev);
acce2633 Pankaj Gupta 2018-08-31  210  out_err:
acce2633 Pankaj Gupta 2018-08-31  211  	dev_err(&vdev->dev, "failed to register virtio pmem memory\n");
acce2633 Pankaj Gupta 2018-08-31  212  	return err;
acce2633 Pankaj Gupta 2018-08-31  213  }
acce2633 Pankaj Gupta 2018-08-31  214  
acce2633 Pankaj Gupta 2018-08-31  215  static void virtio_pmem_remove(struct virtio_device *vdev)
acce2633 Pankaj Gupta 2018-08-31  216  {
acce2633 Pankaj Gupta 2018-08-31  217  	struct virtio_pmem *vpmem = vdev->priv;
acce2633 Pankaj Gupta 2018-08-31  218  	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
acce2633 Pankaj Gupta 2018-08-31  219  
acce2633 Pankaj Gupta 2018-08-31 @220  	nvdimm_bus_unregister(nvdimm_bus);
acce2633 Pankaj Gupta 2018-08-31  221  	vdev->config->del_vqs(vdev);
acce2633 Pankaj Gupta 2018-08-31  222  	kfree(vpmem);
acce2633 Pankaj Gupta 2018-08-31  223  }
acce2633 Pankaj Gupta 2018-08-31  224  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
