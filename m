Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F2482096FAD0
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 03:40:51 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153186087257.27463.13382652631526471099.stgit@djiang5-desk3.ch.intel.com>
References: <153186087257.27463.13382652631526471099.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v5 05/12] keys: add call key_put_sync() to flush
 key_gc_work when doing a key_put().
MIME-Version: 1.0
Content-ID: <5958.1531910449.1@warthog.procyon.org.uk>
Date: Wed, 18 Jul 2018 11:40:49 +0100
Message-ID: <5959.1531910449@warthog.procyon.org.uk>
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

> +static void __key_put(struct key *key, bool sync)
> +{
> +	if (key) {
> +		key_check(key);
> +
> +		if (refcount_dec_and_test(&key->usage)) {
> +			schedule_work(&key_gc_work);
> +			if (sync)
> +				flush_work(&key_gc_work);
> +		}
> +	}
> +}

I'm not sure this is a good way to go about it.  This assumes that the gc will
do an entire pass before returning to the dispatcher, but that won't
necessarily always be the case.  Further, it might take two passes to get rid
of a key that has expired, been revoked or been invalidated: the first pass
removes the links and then a second pass might be needed to remove the key,
depending on the serial number of the key relative to the serial numbers of
the keyrings linking to it.  RCU synchronisation is then performed before the
key can actually be cleaned up.

A better way might be to add a global waitqueue and then use that to watch for
an indication that a key is about to be finally destroyed.  A flag can be set
on the key to ask for the waitqueue to be poked

David.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
