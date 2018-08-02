Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C57D210D6935
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 04:58:14 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153255233354.51274.8552293701029405599.stgit@djiang5-desk3.ch.intel.com>
References: <153255233354.51274.8552293701029405599.stgit@djiang5-desk3.ch.intel.com>
 <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v6 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
MIME-Version: 1.0
Content-ID: <19806.1533211091.1@warthog.procyon.org.uk>
Date: Thu, 02 Aug 2018 12:58:11 +0100
Message-ID: <19807.1533211091@warthog.procyon.org.uk>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> wrote:

> +	key = key_lookup(nvdimm->key_id);

You should not be using key_lookup() as the key ID doesn't pin a reference to
the key you're using.  If you're going to cache a key, either cache the key
pointer directly and check it with key_validate() before you use it or keep
the cache in a private kernel keyring and use key_search() each time you want
to use it.  The latter method allows for the key to be garbage collected
automatically if it expires or gets invalidated.

You can still follow a negative call for a cached key with a call to
nvdimm_request_key().  In the private keyring-using case, you can link the key
to the private keyring after you got it.

> +	payload = key->payload.data[0];
> +	rc = nvdimm->security_ops->unlock(nvdimm_bus, nvdimm,
> +			(void *)payload->data);

I would recommend casting to const void * if you can as you're not allowed to
change the payload data.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
