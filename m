Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACD292096FAD0
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 04:14:19 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
References: <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <9359.1531912457.1@warthog.procyon.org.uk>
Date: Wed, 18 Jul 2018 12:14:17 +0100
Message-ID: <9360.1531912457@warthog.procyon.org.uk>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> wrote:

> Add support for setting and/or updating passphrase on the Intel nvdimms.
> The passphrase is pulled from userspace through the kernel key management.
> We trigger the update via writing "update" to the sysfs attribute
> "security". The state of the security can also be read via the "security"
> attribute. libnvdimm will generically support the key_change API call.

Btw, could you use a logon-type key rather than spinning your own?  Do you
specifically not want it to be updateable?

> +static int intel_dimm_security_update_passphrase(
> +		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
> +		struct nvdimm_key_data *old_data,
> +		struct nvdimm_key_data *new_data)

You might want to mark old_data and new_data as const here.  At least, they
don't appear to be changed.  Also, can you stick a banner comment on the
function to say what it actually does?  Is it changing the key stored in h/w
or is it meant to be changing what's stored in the key payload?

> +	/* request new key from userspace */
> +	key = nvdimm_request_key(dev);
> +	if (!key) {
> +		dev_dbg(dev, "%s: failed to acquire new key\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	dev_dbg(dev, "%s: new key: %#x\n", __func__, key->serial);
> +
> +	if (key->datalen == NVDIMM_PASSPHRASE_LEN) {
> +		old_data = NULL;
> +		new_data = key->payload.data[0];
> +	} else if (key->datalen == (NVDIMM_PASSPHRASE_LEN * 2)) {
> +		new_data = key->payload.data[0];
> +		old_data = new_data + NVDIMM_PASSPHRASE_LEN;
> +	} else {
> +		key_invalidate(key);
> +		key_put(key);
> +		dev_warn(dev, "Incorrect key payload size for update: %u\n",
> +				key->datalen);
> +		return -EINVAL;
> +	}
> +
> +	down_read(&key->sem);
> +	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_data,
> +			new_data);

Why do you need to get a read lock on key->sem and not a write-lock?

> +	if (rc == 0 && key->datalen == (NVDIMM_PASSPHRASE_LEN * 2))
> +		memcpy(old_data, new_data, NVDIMM_PASSPHRASE_LEN);

You appear to be changing the key content here.  If that's the case, don't you
need to write-lock key->sem?

> +	up_read(&key->sem);

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
