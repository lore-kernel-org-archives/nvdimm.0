Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ushosting.nmnhosting.com (ushosting.nmnhosting.com
 [66.55.73.32]) by ml01.01.org (Postfix) with ESMTP id 181EE212A36DD
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 23:07:51 -0700 (PDT)
Message-ID: <214e5c621bf101a92c7abdf815a7300f0dacf496.camel@d-silva.org>
Subject: Re: [PATCH] nvdimm: remove prototypes for nonexistent functions
From: "Alastair D'Silva" <alastair@d-silva.org>
Date: Wed, 26 Jun 2019 16:07:29 +1000
In-Reply-To: <20190626060350.15715-1-alastair@au1.ibm.com>
References: <20190626060350.15715-1-alastair@au1.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-06-26 at 16:03 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> These functions don't exist, so remove the prototypes for them.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  drivers/nvdimm/nd-core.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index 391e88de3a29..57d162dbefaa 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -136,11 +136,7 @@ void nd_region_disable(struct nvdimm_bus
> *nvdimm_bus, struct device *dev);
>  int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
>  void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
>  void nd_synchronize(void);
> -int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
> -int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
> -int nvdimm_bus_init_interleave_sets(struct nvdimm_bus *nvdimm_bus);
>  void __nd_device_register(struct device *dev);
> -int nd_match_dimm(struct device *dev, void *data);
>  struct nd_label_id;
>  char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32
> flags);
>  bool nd_is_uuid_unique(struct device *dev, u8 *uuid);


Whoops, fat-fingered this, nothing has changed.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
