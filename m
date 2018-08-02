Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14690210C642A
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 05:00:56 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
References: <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
 <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v6 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <20100.1533211253.1@warthog.procyon.org.uk>
Date: Thu, 02 Aug 2018 13:00:53 +0100
Message-ID: <20101.1533211253@warthog.procyon.org.uk>
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

> +	/* request new key from userspace */
> +	key = nvdimm_request_key(dev, update);
> +	if (!key) {
> +		dev_dbg(dev, "%s: failed to acquire new key\n", __func__);
> +		rc = -ENXIO;
> +		goto out;
> +	}

I still think you're better taking two explicit key IDs as part of the command
rather than using request_key() to *hopefully* pick the right target.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
