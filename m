Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BFFA21E1DAEC
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 05:54:41 -0700 (PDT)
Date: Fri, 4 Aug 2017 20:55:50 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 8/8] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <201708042002.vbCbzyBJ%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150180315203.66052.12255427047469222345.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, vinod.koul@intel.com, kbuild-all@01.org, dmaengine@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.13-rc3]
[cannot apply to next-20170804]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/Adding-blk-mq-and-DMA-support-to-pmem-block-driver/20170804-191719
config: i386-randconfig-x018-201731 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers//nvdimm/pmem.c: In function 'pmem_handle_cmd_dma':
>> drivers//nvdimm/pmem.c:416:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      unmap->addr[1] = (dma_addr_t)cmd->sg;
                       ^
   drivers//nvdimm/pmem.c:421:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      unmap->addr[0] = (dma_addr_t)cmd->sg;
                       ^

vim +416 drivers//nvdimm/pmem.c

   347	
   348	static int pmem_handle_cmd_dma(struct pmem_cmd *cmd, bool is_write)
   349	{
   350		struct request *req = cmd->rq;
   351		struct request_queue *q = req->q;
   352		struct pmem_device *pmem = q->queuedata;
   353		struct device *dev = to_dev(pmem);
   354		phys_addr_t pmem_off = blk_rq_pos(req) * 512 + pmem->data_offset;
   355		void *pmem_addr = pmem->virt_addr + pmem_off;
   356		struct nd_region *nd_region = to_region(pmem);
   357		size_t len;
   358		struct dma_device *dma = cmd->chan->device;
   359		struct dmaengine_unmap_data *unmap;
   360		dma_cookie_t cookie;
   361		struct dma_async_tx_descriptor *txd;
   362		struct page *page;
   363		unsigned int off;
   364		int rc;
   365		enum dma_data_direction dir;
   366		dma_addr_t dma_addr;
   367	
   368		if (req->cmd_flags & REQ_FLUSH)
   369			nvdimm_flush(nd_region);
   370	
   371		unmap = dmaengine_get_unmap_data(dma->dev, 2, GFP_NOWAIT);
   372		if (!unmap) {
   373			dev_dbg(dev, "failed to get dma unmap data\n");
   374			rc = -ENOMEM;
   375			goto err;
   376		}
   377	
   378		/*
   379		 * If reading from pmem, writing to scatterlist,
   380		 * and if writing to pmem, reading from scatterlist.
   381		 */
   382		dir = is_write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
   383		cmd->sg_nents = blk_rq_map_sg(req->q, req, cmd->sg);
   384		if (cmd->sg_nents < 1) {
   385			rc = -EINVAL;
   386			goto err;
   387		}
   388	
   389		if (cmd->sg_nents > 128) {
   390			rc = -ENOMEM;
   391			dev_warn(dev, "Number of sg greater than allocated\n");
   392			goto err;
   393		}
   394	
   395		rc = dma_map_sg(dma->dev, cmd->sg, cmd->sg_nents, dir);
   396		if (rc < 1) {
   397			rc = -ENXIO;
   398			goto err;
   399		}
   400	
   401		len = blk_rq_payload_bytes(req);
   402		page = virt_to_page(pmem_addr);
   403		off = offset_in_page(pmem_addr);
   404		dir = is_write ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
   405		dma_addr = dma_map_page(dma->dev, page, off, len, dir);
   406		if (dma_mapping_error(dma->dev, unmap->addr[0])) {
   407			dev_dbg(dma->dev, "src DMA mapping error\n");
   408			rc = -ENXIO;
   409			goto err_unmap_sg;
   410		}
   411	
   412		unmap->len = len;
   413	
   414		if (is_write) {
   415			unmap->addr[0] = dma_addr;
 > 416			unmap->addr[1] = (dma_addr_t)cmd->sg;
   417			unmap->to_cnt = 1;
   418			unmap->from_cnt = 0;
   419			dma_unmap_data_sg_from_nents(unmap, 2) = cmd->sg_nents;
   420		} else {
   421			unmap->addr[0] = (dma_addr_t)cmd->sg;
   422			unmap->addr[1] = dma_addr;
   423			unmap->from_cnt = 1;
   424			unmap->to_cnt = 0;
   425			dma_unmap_data_sg_to_nents(unmap, 2) = cmd->sg_nents;
   426		}
   427	
   428		txd = dma->device_prep_dma_memcpy_sg(cmd->chan,
   429					cmd->sg, cmd->sg_nents, dma_addr,
   430					!is_write, DMA_PREP_INTERRUPT);
   431		if (!txd) {
   432			dev_dbg(dma->dev, "dma prep failed\n");
   433			rc = -ENXIO;
   434			goto err_unmap_buffer;
   435		}
   436	
   437		txd->callback_result = nd_pmem_dma_callback;
   438		txd->callback_param = cmd;
   439		dma_set_unmap(txd, unmap);
   440		cookie = dmaengine_submit(txd);
   441		if (dma_submit_error(cookie)) {
   442			dev_dbg(dma->dev, "dma submit error\n");
   443			rc = -ENXIO;
   444			goto err_set_unmap;
   445		}
   446	
   447		dmaengine_unmap_put(unmap);
   448		dma_async_issue_pending(cmd->chan);
   449	
   450		return 0;
   451	
   452	err_set_unmap:
   453		dmaengine_unmap_put(unmap);
   454	err_unmap_buffer:
   455		dma_unmap_page(dev, dma_addr, len, dir);
   456	err_unmap_sg:
   457		if (dir == DMA_TO_DEVICE)
   458			dir = DMA_FROM_DEVICE;
   459		else
   460			dir = DMA_TO_DEVICE;
   461		dma_unmap_sg(dev, cmd->sg, cmd->sg_nents, dir);
   462		dmaengine_unmap_put(unmap);
   463	err:
   464		blk_mq_end_request(cmd->rq, rc);
   465		return rc;
   466	}
   467	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
