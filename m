Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 382C521BADAB2
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 01:28:58 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <465ca753-ad2c-6888-b139-8cb9c4472290@intel.com>
References: <465ca753-ad2c-6888-b139-8cb9c4472290@intel.com>
 <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
 <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
 <20101.1533211253@warthog.procyon.org.uk>
Subject: Re: [PATCH v6 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <24762.1533284933.1@warthog.procyon.org.uk>
Date: Fri, 03 Aug 2018 09:28:53 +0100
Message-ID: <24764.1533284933@warthog.procyon.org.uk>
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

> In order to do this, I would need to do a key_add() in userspace to add

Well, add_key().

> a new key with the new payload before I can initiate update correct? So
> for an update it would look something like:
> 1. (user) add key with new payload
> 2. (user) lookup old key

You don't technically need the old key - just a key with the old password in
it.  It doesn't need to have any useful description since you're providing it
directly.

> 3. (user) write to sysfs update attrib: "update:<old id>:<new id>"
> 4. (kernel) check old_id against cached key and make sure they match
> 5. (kernel) check new key desc against old key and make sure they match
> 6. (kernel) update to hardware
> 6. (kernel) when success, link the new key to the kernel keyring and
> it'll replace the old key?

Yep - provided it has the same description.  A keyring can only keep one key
of any {type, description} at any one time.  Adding a second will displace the
first.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
