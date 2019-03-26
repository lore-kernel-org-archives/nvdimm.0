Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E426821959CB2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 13:29:01 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w137so11052625oiw.5
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 13:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <155361997046.42665.15819732417231761031.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155361997046.42665.15819732417231761031.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Mar 2019 13:28:49 -0700
Message-ID: <CAPcyv4gFJRN3pyzXBsUh0MbXkY_vDBCLpsiAOkK7+rY=A_frfQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] libnvdimm/security: Support a zero-key for
 secure-erase
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 26, 2019 at 10:06 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Adding support to allow secure erase to happen when security state is not
> enabled. Key data of 0's will be passed in.

That still sounds more like a feature than a fix, and if I'm looking
closer than the fix is to make sure that all nvdimm_lookup_user_key()
invocations always return data, at least for all the "current / old"
passphrase cases. Because, afaics there's no way to unlock a DIMM if a
platform implements a zero-key default.

Also the current "freeze on no key" functionality will fail if the
DIMM expects the zero-key.

nvdimm_lookup_user_key(good_key_id, current_key) => user key payload

nvdimm_lookup_user_key(bad_key_id) => zero key payload, but should
fail if this was the key-id for the new-passphrase / key

nvdimm_lookup_user_key(0) => zero key payload.

This guarantees that zero-key semantic is uniform across all current /
old-passphrase use cases.

> Some other security commands already use zero keys. This is to unifiy
> semantics cross commands with respect to using zero keys.

We should say a bit why this is important and the knowledge that there
are some platforms that default to a zero-key. This is the primary
justification for the change. For a -rc change of this nature the
status as a fix needs to be clear otherwise it will be deferred to
v5.2. For example if I were Linus I would reject any patch that starts
"Adding support" and not read the rest of the changelog at this stage
of the development cycle.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
