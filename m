Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150926011742.2848.89427.stgit@dwillia2-desk3.jf.intel.com>
References: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
	<20150926011742.2848.89427.stgit@dwillia2-desk3.jf.intel.com>
Date: Tue, 29 Sep 2015 17:30:26 -0700
Message-ID: <CAPcyv4hzefF90mxm9yOCmKcDxFc_Wz_BcH3b14Mi5W-vt0gi9w@mail.gmail.com>
Subject: Re: [PATCH 1/3] devm: make allocations numa aware by default
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Tejun, any thoughts on this, or concerns about globally enabling
numa hints for devm allocations?

On Fri, Sep 25, 2015 at 6:17 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Given we already have a device just use dev_to_node() to provide hint
> allocations for devres.  However, current devres_alloc() users will need
> to explicitly opt-in with devres_alloc_node().
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/base/devres.c  |   19 ++++++++++---------
>  include/linux/device.h |   16 ++++++++++++----
>  2 files changed, 22 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 875464690117..8fc654f0807b 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -82,12 +82,12 @@ static struct devres_group * node_to_group(struct devres_node *node)
>  }
>
>  static __always_inline struct devres * alloc_dr(dr_release_t release,
> -                                               size_t size, gfp_t gfp)
> +                                               size_t size, gfp_t gfp, int nid)
>  {
>         size_t tot_size = sizeof(struct devres) + size;
>         struct devres *dr;
>
> -       dr = kmalloc_track_caller(tot_size, gfp);
> +       dr = kmalloc_node_track_caller(tot_size, gfp, nid);
>         if (unlikely(!dr))
>                 return NULL;
>
> @@ -106,24 +106,25 @@ static void add_dr(struct device *dev, struct devres_node *node)
>  }
>
>  #ifdef CONFIG_DEBUG_DEVRES
> -void * __devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
> +void * __devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp, int nid,
>                       const char *name)
>  {
>         struct devres *dr;
>
> -       dr = alloc_dr(release, size, gfp | __GFP_ZERO);
> +       dr = alloc_dr(release, size, gfp | __GFP_ZERO, nid);
>         if (unlikely(!dr))
>                 return NULL;
>         set_node_dbginfo(&dr->node, name, size);
>         return dr->data;
>  }
> -EXPORT_SYMBOL_GPL(__devres_alloc);
> +EXPORT_SYMBOL_GPL(__devres_alloc_node);
>  #else
>  /**
>   * devres_alloc - Allocate device resource data
>   * @release: Release function devres will be associated with
>   * @size: Allocation size
>   * @gfp: Allocation flags
> + * @nid: NUMA node
>   *
>   * Allocate devres of @size bytes.  The allocated area is zeroed, then
>   * associated with @release.  The returned pointer can be passed to
> @@ -132,16 +133,16 @@ EXPORT_SYMBOL_GPL(__devres_alloc);
>   * RETURNS:
>   * Pointer to allocated devres on success, NULL on failure.
>   */
> -void * devres_alloc(dr_release_t release, size_t size, gfp_t gfp)
> +void * devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp, int nid)
>  {
>         struct devres *dr;
>
> -       dr = alloc_dr(release, size, gfp | __GFP_ZERO);
> +       dr = alloc_dr(release, size, gfp | __GFP_ZERO, nid);
>         if (unlikely(!dr))
>                 return NULL;
>         return dr->data;
>  }
> -EXPORT_SYMBOL_GPL(devres_alloc);
> +EXPORT_SYMBOL_GPL(devres_alloc_node);
>  #endif
>
>  /**
> @@ -776,7 +777,7 @@ void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
>         struct devres *dr;
>
>         /* use raw alloc_dr for kmalloc caller tracing */
> -       dr = alloc_dr(devm_kmalloc_release, size, gfp);
> +       dr = alloc_dr(devm_kmalloc_release, size, gfp, dev_to_node(dev));
>         if (unlikely(!dr))
>                 return NULL;
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 5d7bc6349930..b8f411b57dcb 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -604,13 +604,21 @@ typedef void (*dr_release_t)(struct device *dev, void *res);
>  typedef int (*dr_match_t)(struct device *dev, void *res, void *match_data);
>
>  #ifdef CONFIG_DEBUG_DEVRES
> -extern void *__devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
> -                            const char *name);
> +extern void *__devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp,
> +                                int nid, const char *name);
>  #define devres_alloc(release, size, gfp) \
> -       __devres_alloc(release, size, gfp, #release)
> +       __devres_alloc_node(release, size, gfp, NUMA_NO_NODE, #release)
> +#define devres_alloc_node(release, size, gfp, nid) \
> +       __devres_alloc_node(release, size, gfp, nid, #release)
>  #else
> -extern void *devres_alloc(dr_release_t release, size_t size, gfp_t gfp);
> +extern void *devres_alloc_node(dr_release_t release, size_t size, gfp_t gfp,
> +                              int nid);
> +static inline void *devres_alloc(dr_release_t release, size_t size, gfp_t gfp)
> +{
> +       return devres_alloc_node(release, size, gfp, NUMA_NO_NODE);
> +}
>  #endif
> +
>  extern void devres_for_each_res(struct device *dev, dr_release_t release,
>                                 dr_match_t match, void *match_data,
>                                 void (*fn)(struct device *, void *, void *),
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
