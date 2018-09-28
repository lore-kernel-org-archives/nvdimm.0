Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E1132112872F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 01:45:57 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <153799483810.71621.11639561453544624699.stgit@djiang5-desk3.ch.intel.com>
References: <153799483810.71621.11639561453544624699.stgit@djiang5-desk3.ch.intel.com>
 <153799466529.71621.10728628542331983376.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v10 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <26386.1538124354.1@warthog.procyon.org.uk>
Date: Fri, 28 Sep 2018 09:45:54 +0100
Message-ID: <26387.1538124354@warthog.procyon.org.uk>
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

> +	down_read(&key->sem);
> +	payload = key->payload.data[0];
> +	down_read(&user_key->sem);
> +	upayload = user_key->payload.data[0];

Personally, I would do both downs first and then deref both payloads.  The
compiler probably will be blocked from rearranging things to move the first
deref after the second down.  Ideally it or the cpu should be able to move
things into the critical section, but the cpu barriers available may well
preclude that.  That means that the compiler has to use a resource (stack/reg)
to stash the value across the second down.

> +	 * We don't need to release key->sem here because nvdimm_repalce_key

nvdimm_replace_key I presume.

> +	sscanf(buf, "%s %u %u", cmd, &old_key, &new_key);

You should check that sscanf() returned 3.

Also, since there's no size limitation here on the cmd string, if someone, for
example, writes a string of SEC_CMD_SIZE lots of 'a', sscanf() will write all
of them into cmd[] and follow that with a NUL char, thereby overrunning your
cmd[] buffer.  You need to either make the buffer one bigger or put a size
limit in sscanf string, e.g.:

	if (sscanf(buf, "%" __stringify(SEC_CMD_SIZE) "s %u %u", ...) == 3)

-~-
Other than that, I think this is mostly right.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
