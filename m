Received: from camel.birch.relay.mailchannels.net (camel.birch.relay.mailchannels.net [23.83.209.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D04A25
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 22:18:35 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 53AB2821C6C;
	Wed, 13 Jul 2022 18:50:23 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9A5CF82174E;
	Wed, 13 Jul 2022 18:50:22 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657738222; a=rsa-sha256;
	cv=none;
	b=UUppOku8LPhamUxSGttkazOMuOwwff/Vbops76WRmTEDKgnhdq7/6EXUHcxvNYxcF3gL/U
	FZhfS6Q6JRyi5i9GcmoDTlm+g6nZ7bGsm4p95/8Z8vXIvQtgBLzjY9nhy1dKan6SgRh+EP
	oaG4G6vnYwnpv/UtzKDPJeXIYuui9r4Ea15ilReZVjxZgxlPW4z3DhasEjHnWvLAvP4bsm
	8ZbNSnsglrRB68XzhBZ9fA9J6hPX6qU/91JEW9Qu/bFoOu0bNc86U4wqtGEZEaYXnLGSNM
	kfnGuxhGuOwAf23wwdWvOuwe1IYnExmjb7NaaqGSSztH2LI+ySS+tyvPFP6MdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657738222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8AED1lF7dvJPm0lHK13/+6VUmfKS8/FA6eiL/czFBg=;
	b=szmeFQ3sBRjb9B+gRlCKqitwiYRBMyba8jQq9Gw1cONt70AE98cAatRhEdd//4gOwEP7y1
	Yk5Q02iQ60bajTJQcwuVZE2uHpVEMD6i0rfD1Vy2lAlZgnf6IhqZFz0TmmHEh9HF0G32oT
	MFPdcMLmngFcmI+poHDtDaSo7QB35XBDdT9BqlDdvx5z0+xldl10LrgkTN/zyj4km3w0cU
	VOzJG9c5IeTglABP+t+93TGgjaCqvcDT9z2RCKUCAYXBpGnd1s4M67x2RpSVw+QrNlxNWj
	bJystH3wyYZ/Pzgjz1d9RST4cT1L8ZicQDY05znb1vSBH7yruxbk3aQW6SEs0w==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-n77jc;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Thread-Harbor: 2afb5dd7407be59d_1657738222943_2799375809
X-MC-Loop-Signature: 1657738222943:270843918
X-MC-Ingress-Time: 1657738222943
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.67.142 (trex/6.7.1);
	Wed, 13 Jul 2022 18:50:22 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4Ljms952GfzBQ;
	Wed, 13 Jul 2022 11:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657738222;
	bh=C8AED1lF7dvJPm0lHK13/+6VUmfKS8/FA6eiL/czFBg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=VHKEhn0pnLY5mShx0PSGO+8AttmqNXQMGcBMJYbEtSYlDr3bQgfhUzs/wb0ID7u31
	 1OEhdcSKyOwTEXoh1kk7mPmLxarosKWoyWZ85SJNIpf8AZiXMzgf4957q1rvx9VGaI
	 0Xwq3znDl6+G1Dh9TBLmgHONbPTFTbUa/PVvbXQkK+FBdka2WK0BYJYLA1YP9uqs6n
	 3LEJhRbUtGPgxNGsHqMcIzeKZsEfYaXUTWMnaywCM7oAhNPpTHpfpsxZYNxavLBLtA
	 ZlV9bpM5mE2aJ2yJ4ZjtLCkSRv7hRnuGKaJeFT1uphht9lacyzbbunvY8MJV88ZwMr
	 KHuU4dFpSF/Bw==
Date: Wed, 13 Jul 2022 11:50:18 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>, a.manzanares@samsung.com
Subject: Re: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Message-ID: <20220713185018.lfrq6uunaigpc6u2@offworld>
References: <20220713075157.411479-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220713075157.411479-1-vishal.l.verma@intel.com>
User-Agent: NeoMutt/20220429

On Wed, 13 Jul 2022, Vishal Verma wrote:

>Add a unit test to test writing, reading, and zeroing LSA aread for
>cxl_test based memdevs using ndctl commands.
>
>Cc: Dan Williams <dan.j.williams@intel.com>
>Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>---
> test/cxl-labels.sh | 53 ++++++++++++++++++++++++++++++++++++++++++++++
> test/meson.build   |  2 ++
> 2 files changed, 55 insertions(+)
> create mode 100644 test/cxl-labels.sh
>
>diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
>new file mode 100644
>index 0000000..ce73963
>--- /dev/null
>+++ b/test/cxl-labels.sh
>@@ -0,0 +1,53 @@
>+#!/bin/bash
>+# SPDX-License-Identifier: GPL-2.0
>+# Copyright (C) 2022 Intel Corporation. All rights reserved.
>+
>+. $(dirname $0)/common
>+
>+rc=1
>+
>+set -ex
>+
>+trap 'err $LINENO' ERR
>+
>+check_prereq "jq"
>+
>+modprobe -r cxl_test
>+modprobe cxl_test
>+udevadm settle
>+
>+test_label_ops()
>+{
>+	nmem="$1"
>+	lsa=$(mktemp /tmp/lsa-$nmem.XXXX)
>+	lsa_read=$(mktemp /tmp/lsa-read-$nmem.XXXX)
>+
>+	# determine LSA size
>+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
>+	lsa_size=$(stat -c %s "$lsa_read")
>+
>+	dd "if=/dev/urandom" "of=$lsa" "bs=$lsa_size" "count=1"
>+	"$NDCTL" write-labels -i "$lsa" "$nmem"
>+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
>+
>+	# compare what was written vs read
>+	diff "$lsa" "$lsa_read"
>+
>+	# zero the LSA and test
>+	"$NDCTL" zero-labels "$nmem"
>+	dd "if=/dev/zero" "of=$lsa" "bs=$lsa_size" "count=1"
>+	"$NDCTL" read-labels -o "$lsa_read" "$nmem"
>+	diff "$lsa" "$lsa_read"
>+
>+	# cleanup
>+	rm "$lsa" "$lsa_read"
>+}
>+
>+# find nmem devices corresponding to cxl memdevs
>+readarray -t nmems < <("$NDCTL" list -b cxl_test -Di | jq -r '.[].dev')

s/$NDCTL/$CXL

Beyond sharing a repo, I would really avoid mixing and matching ndctl and cxl
tooling and thereby keep them self sufficient. I understand that there are cases
where pmem specific operations can can be done reusing relevant pmem/nvdimm/ndctl
machinery and interfaces, but I don't see this as the case for something like lsa
unit testing.

Thanks,
Davidlohr

>+
>+for nmem in ${nmems[@]}; do
>+	test_label_ops "$nmem"
>+done
>+
>+modprobe -r cxl_test
>diff --git a/test/meson.build b/test/meson.build
>index fbcfc08..687a71f 100644
>--- a/test/meson.build
>+++ b/test/meson.build
>@@ -152,6 +152,7 @@ pfn_meta_errors = find_program('pfn-meta-errors.sh')
> track_uuid = find_program('track-uuid.sh')
> cxl_topo = find_program('cxl-topology.sh')
> cxl_region = find_program('cxl-region-create.sh')
>+cxl_labels = find_program('cxl-labels.sh')
>
> tests = [
>   [ 'libndctl',               libndctl,		  'ndctl' ],
>@@ -178,6 +179,7 @@ tests = [
>   [ 'track-uuid.sh',          track_uuid,	  'ndctl' ],
>   [ 'cxl-topology.sh',	      cxl_topo,		  'cxl'   ],
>   [ 'cxl-region-create.sh',   cxl_region,	  'cxl'   ],
>+  [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
> ]
>
> if get_option('destructive').enabled()
>--
>2.36.1
>
