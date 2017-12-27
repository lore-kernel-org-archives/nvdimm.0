Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A974C22280C42
 for <linux-nvdimm@lists.01.org>; Wed, 27 Dec 2017 10:03:41 -0800 (PST)
Date: Wed, 27 Dec 2017 11:08:36 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 08/18] tools/testing/nvdimm: add 'bio_delay' mechanism
Message-ID: <20171227180836.GA14641@linux.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407700353.38751.17609507477918854876.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:43PM -0800, Dan Williams wrote:
> In support of testing truncate colliding with dma add a mechanism that
> delays the completion of block I/O requests by a programmable number of
> seconds. This allows a truncate operation to be issued while page
> references are held for direct-I/O.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

> @@ -387,4 +389,64 @@ union acpi_object * __wrap_acpi_evaluate_dsm(acpi_handle handle, const guid_t *g
>  }
>  EXPORT_SYMBOL(__wrap_acpi_evaluate_dsm);
>  
> +static DEFINE_SPINLOCK(bio_lock);
> +static struct bio *biolist;
> +int bio_do_queue;
> +
> +static void run_bio(struct work_struct *work)
> +{
> +	struct delayed_work *dw = container_of(work, typeof(*dw), work);
> +	struct bio *bio, *next;
> +
> +	pr_info("%s\n", __func__);

Did you mean to leave this print in, or was it part of your debug while
developing?  I don't see any other prints in the rest of the nvdimm testing
code?

> +	spin_lock(&bio_lock);
> +	bio_do_queue = 0;
> +	bio = biolist;
> +	biolist = NULL;
> +	spin_unlock(&bio_lock);
> +
> +	while (bio) {
> +		next = bio->bi_next;
> +		bio->bi_next = NULL;
> +		bio_endio(bio);
> +		bio = next;
> +	}
> +	kfree(dw);
> +}
> +
> +void nfit_test_inject_bio_delay(int sec)
> +{
> +	struct delayed_work *dw = kzalloc(sizeof(*dw), GFP_KERNEL);
> +
> +	spin_lock(&bio_lock);
> +	if (!bio_do_queue) {
> +		pr_info("%s: %d seconds\n", __func__, sec);

Ditto with this print - did you mean to leave it in?

> +		INIT_DELAYED_WORK(dw, run_bio);
> +		bio_do_queue = 1;
> +		schedule_delayed_work(dw, sec * HZ);
> +		dw = NULL;

Why set dw = NULL here?  In the else case we leak dw - was this dw=NULL meant
to allow a kfree(dw) after we get out of the if() (and probably after we drop
the spinlock)?

> +	}
> +	spin_unlock(&bio_lock);
> +}
> +EXPORT_SYMBOL_GPL(nfit_test_inject_bio_delay);
> +

> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 7217b2b953b5..9362b01e9a8f 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -872,6 +872,39 @@ static const struct attribute_group *nfit_test_dimm_attribute_groups[] = {
>  	NULL,
>  };
>  
> +static ssize_t bio_delay_show(struct device_driver *drv, char *buf)
> +{
> +	return sprintf(buf, "0\n");
> +}

It doesn't seem like this _show() routine adds much?  We could have it print
out the value of 'bio_do_queue' so we can see if we are currently queueing
bios in a workqueue element, but that suffers pretty badly from a TOCTOU race.

Otherwise we could just omit the _show() altogether and just use
DRIVER_ATTR_WO(bio_delay).

> +
> +static ssize_t bio_delay_store(struct device_driver *drv, const char *buf,
> +		size_t count)
> +{
> +	unsigned long delay;
> +	int rc = kstrtoul(buf, 0, &delay);
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	nfit_test_inject_bio_delay(delay);
> +	return count;
> +}
> +DRIVER_ATTR_RW(bio_delay);

   DRIVER_ATTR_WO(bio_delay);  ?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
