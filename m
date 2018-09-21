Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD292211546EC
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 16:05:22 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAPcyv4jO9-OrBvDNxN6hB4X6bPKnerqkdh812_LjScwe44mX2A@mail.gmail.com>
References: <CAPcyv4jO9-OrBvDNxN6hB4X6bPKnerqkdh812_LjScwe44mX2A@mail.gmail.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <153549646033.4089.17866270311512341456.stgit@djiang5-desk3.ch.intel.com>
Subject: Re: [PATCH v8 04/12] keys: export lookup_user_key to external users
MIME-Version: 1.0
Content-ID: <16511.1537571119.1@warthog.procyon.org.uk>
Date: Sat, 22 Sep 2018 00:05:19 +0100
Message-ID: <16512.1537571119@warthog.procyon.org.uk>
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
Cc: "Schofield, Alison  <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm" <linux-nvdimm@lists.01.org>, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> wrote:

> This looks like a core api for affecting keyctl api internals, should
> it be EXPORT_SYMBOL_GPL?

No, it should be EXPORT_SYMBOL().  Let me look through the other patches.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
