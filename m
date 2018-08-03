Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0D34210D7F20
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 01:32:51 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <00b10de9-1349-491c-8277-8d71536dd1a6@intel.com>
References: <00b10de9-1349-491c-8277-8d71536dd1a6@intel.com>
 <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
 <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
 <20101.1533211253@warthog.procyon.org.uk>
 <465ca753-ad2c-6888-b139-8cb9c4472290@intel.com>
Subject: Re: [PATCH v6 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <25303.1533285169.1@warthog.procyon.org.uk>
Date: Fri, 03 Aug 2018 09:32:49 +0100
Message-ID: <25304.1533285169@warthog.procyon.org.uk>
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

> I think I'm a little confused on what to do once I pass in the new key
> id through update. How do I retrieve the new key in kernel that I added
> from userspace and not use key_lookup()? request_key() or something
> else? Wouldn't request_key come up with the old key since it has the
> same description?

As I keep saying, you need to use lookup_user_key():

	key = lookup_user_key(keyid, 0, KEY_NEED_SEARCH);

You need to add it to linux/key.h and export it.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
