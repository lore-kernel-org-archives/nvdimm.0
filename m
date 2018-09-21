Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 628472194D3AE
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 16:20:53 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
References: <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v8 05/12] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
MIME-Version: 1.0
Content-ID: <17432.1537572050.1@warthog.procyon.org.uk>
Date: Sat, 22 Sep 2018 00:20:50 +0100
Message-ID: <17433.1537572050@warthog.procyon.org.uk>
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

> +	depends on KEYS

That needs to be in patch 2 where you create a keyring.

> +	char desc[NVDIMM_KEY_DESC_LEN + strlen(NVDIMM_PREFIX)];

You should be using sizeof() not strlen() and do you need + 1 for the NUL
char?

> +	sprintf(desc, "%s%s", NVDIMM_PREFIX, nvdimm->dimm_id);

NVDIMM_PREFIX is a constant string.  I would recommend either declaring it as
a const char[] or just sticking it in the format string in place of the %s:

	sprintf(desc, NVDIMM_PREFIX "%s", nvdimm->dimm_id);

> +		if (!cached_key) {
> +			key_link(nvdimm_keyring, key);
> +			nvdimm->key = key;
> +			key->perm |= KEY_USR_SEARCH;
> +		}

Ummm...  You're altering the key permission?  That's not really yours to
change.

> +static int nvdimm_check_key_len(unsigned short len, bool update)
> +{
> +	if (len == (NVDIMM_PASSPHRASE_LEN * 2) && update)
> +		return 0;

In the cover you said:

	- Modified "update" to take two key ids and and use lookup_user_key()
	  in order to improve security.  (David)

is this a holdover?

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
