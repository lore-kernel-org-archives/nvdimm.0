Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794328019;
	b=nbCwo0XBxc2FWQWWIq1TbMKvUzkO0FLsy6jtf8pB9zN+r/gDLbH/nmgo4JpGu68wU8Yu
	 Y0yet4XxqkXoL7My9ka08G6j14NaQAlEZx3/wK4f6IrHlxHkNiEMvW3oXA1/3RwYEw2NR
	 DfcURi+kwMNkS1WP0FAHT1OCRsPvGFzWh1bn3c4Ur4Xs/XkneNLEVFde+FnVxb3oQizW6
	 f2mRaJibLXlM1a87rSrMBH9FWIfzPStedZzr7ITy183QdtqnVy5ULPhGv1PuVndkEbmzY
	 ES9CS0NCFVv5mXWrGWk6FfK2rQz/Frhh9NkMTRynawIiNfad2yh7oS6S7RHlhmpbaRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GMzvWX5SagEzJ935EqXTIXPmka1A6zL3HJbqIIx4Z/A=;
	b=x2tk9yok9dJ2NCEX8V3ltWKJ1Ola8QKV4JV86jqrAPVHsrAUmmUkVaJ46LIYbvJP7dnv
	 EMX5A+d98TMhdiNJWfhKx1PbLWZHOISjoTEffPtKv/Xf3VE1EdOW9Mb1yceI35fjScWA6
	 gHwxByldfats/a3ye6HkuYA7/cbmCkjovuwgrwZvkAh4+t0gUNcA8decaHrJ78bzmKlR9
	 7OjHCrxg36zyxIMwziddTy7WRRZ5Xla83ecvTh8WBUZxM9rZQTaFAfSD7sSozrWObvhad
	 YkcgTTGSp98ODyQ5gTT1ItfZ32wF5R1LIeAOg2CXzMYvhplHKufq/d+juhIpvtTY/gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linbit.com;
	spf=pass smtp.mailfrom=linbit.com;
	dkim=pass header.d=linbit.com header.i=@linbit.com header.a=rsa-sha256 header.s=google header.b=0GXcHwZR;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8C7606A32D
	for <nvdimm@lists.linux.dev>; Tue, 10 Nov 2026 16:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A8C7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit.com header.i=@linbit.com header.a=rsa-sha256 header.s=google header.b=0GXcHwZR
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso1486301f8f.1
        for <nvdimm@lists.linux.dev>; Tue, 10 Nov 2026 08:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit.com; s=google; t=1794328017; x=1794932817; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GMzvWX5SagEzJ935EqXTIXPmka1A6zL3HJbqIIx4Z/A=;
        b=0GXcHwZR9FSl92m6hynS2+iz0VYeY2SdGUaH+OwORa95OaS8MeRWKVn4L5DhA+Fd0z
         gGlsaxDCG8bOcnmH+AT+5cnkT5jkmsrwOOaujTAPyKZb8yLI/MXkGJlDtN/Vv8joWiEW
         w2KAgL3BCIw6smTeWp5EdP8CvsBQLMp3Bwbu2GosYcdWEp+zAlfsU1evRGgC8xrnT3Wq
         lVyZvPR2MoB+jvVCpgLfsdsXrEwLybaHymK+DaaX8POMwUv3Q/hvB/7bwpF++/P3QTom
         6T5T7vgsMl7lD8Vz97LJ2uXKgekIiEjIOEJax8IIIbbc1zjiGcSMCBPZiM+IKcUqo4fh
         3GYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794328017; x=1794932817;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GMzvWX5SagEzJ935EqXTIXPmka1A6zL3HJbqIIx4Z/A=;
        b=JsBTkHmDkg0kIG4dAGi+r4iJnI/1YZdFuKs5I+soz+/K0DhG5AFFto51GHKJNeojTE
         Fi3TfzYXOEvGYm/ZE3KF+mHLB3aBuzSGc4z9tYKPH1as8MtmrtCtR2DOfnodpbC7R3IQ
         FdvmUVUbTRztWq7nxhZe+9kGX/f9zNXfcGbsavV1y4Yx+yPtFsxKp5xx1N7+IHg/HW8n
         yYJZf4e0tSJwc3rvRlpkIeZgI6zq2UzyHqSuBmjRP+HZ+/mKWnGIKj8Kcv0G+M6GYytu
         Bi0zXB8w55h1ZWJUyMjJM/rJ58IWkx2tXh1ADm7+u3ANceDcWo10hA7pXPJp1ypZEWWC
         wRtw==
X-Forwarded-Encrypted: i=1; AL+hErHOvp3UxicL50WZUWhstJQbr9kivmj6e5hzABS9ILJlLFEu+UHzIqT8GxwqGdkmciHK1i3iznA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Rs8tSQBYyZ3V4FgiRvPZzU2T/uqV9D56xmQ4+17Z3k6E5o5wx
	m7AJ7tpRlgPDfnVadlLKVv0Kjm6IiHoLlRo2PutKYZjTcQ/kY2oHd9s3UDtOIdUkrR0=
X-Gm-Gg: AYBFou2o6OaQrHKzdfTPSFSmCYWgPEsSSh4LKLpnlp/G1olNG6EG9niHFvsVzBktsiX
	v1JM9zre8NHi0osKVvCLZ0F2F+qnP/AqrygAwH5PR7DbBxhk/5dwpYg8Z/5sU5GgK85iJN2OSd0
	2bwD3vibXMePkW5tv87pCEepcvHf2ejJgXaE+0y9v34wmQF3/5ufBOMY8fjVzOM0xpUOgRN/tL1
	GGtdzNua1TyTu85KS8gXzfVVt5MgbZDvgdfzUvZDgzP3+hfFe/2dDDGwsIHq9CBPiuIpGFhxs82
	BgNJTXguA4vn148Lw7KykQOcmpR2cRhhs/268v3P24E7Gb+SXQLQJtWJyKjgmLP0DcdiL7J0N+j
	SmDsVqXlPQQxwwcy+reX015ihSsuiDBKsUX6QxIGd16wrkxRpjepf7VRg9n3vaZK1eB1t/OWowf
	8UvpohsvUMpXq4L1xsdQP4RIyjyzHvGRYAHlmzkfj8tnerihBUoOAABES9mPe96fMjUL81LqUje
	h7GIvSxHx1+t5cnfuHMjQ8aHCsdj4kMHLSh7E+EdrqokEXgT78uskLXZX58SNqOvo1aqpcPLfQi
	8gB2YjjQZOJCgiDeCZVaUm/EV0cYFOayBl3pVyE0yRZ7j+96BZhm25VY+ghLd6z7In6f7ZFDPQ=
	=
X-Received: by 2002:a05:600c:348a:b0:4a1:efbe:529c with SMTP id 5b1f17b1804b1-4ba0234d97amr55868865e9.12.1794328016738;
        Tue, 10 Nov 2026 08:26:56 -0800 (PST)
Received: from linbit.com (h082218129081.host.wavenet.at. [82.218.129.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba02345d22sm85050695e9.1.2026.11.10.08.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:26:56 -0800 (PST)
From: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 00/20] drbd: DRBD 9 rework
Date: Tue, 10 Nov 2026 17:26:25 +0100
Message-ID: <20261110162646.3028472-1-christoph.boehmwalder@linbit.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

As discussed (context: [0]), here is our DRBD 9 rework series, intended
for linux-next via for-7.x/drbd.

This replays about 10-15 years of active out-of-tree development work
[1], depending on your way of counting. The out-of-tree module has
severely diverged from the in-tree version over the years, which is
what we are aiming to fix now.

Hopefully that somewhat excuses (or at least explains) the massive
diffs -- we've tried to come up with a way to group the changes by
topic, but I realize it's still not exactly trivial to review.

We've been polishing this series for a while now, and we have taken
great care to make it as "upstream-presentable" as possible. That said,
there are still probably imperfections. It's a start -- feedback
welcome!

The netlink interface has been reworked so that userspace is not
broken: the existing "drbd" generic netlink family keeps being served
at version 1, and this series does not touch its generated
serialization or its UAPI header.
Every shipped drbd-utils release therefore keeps working against this
driver. DRBD 9's own utilities speak a new family, "drbd2", written as
a YNL specification under Documentation/netlink/specs/ and following
current genetlink conventions; its generated code is checked in as
usual. The driver registers both families and translates each onto the
same wire-neutral core, so the multi-peer administration model is only
reachable through drbd2, while version-1 clients see the single-peer
semantics they expect.

The RDMA and load-balancing TCP (lb-tcp) transports are not part of
this series; they will be submitted separately once they have had the
same treatment. The rdma_ctrl_rcvbuf_size
and rdma_ctrl_sndbuf_size net options do remain in the UAPI: they are
generic transport options that are interpreted by whichever transport is
in use, so there is no reason to remove and later re-add them.

The base for these patches is for-7.5/block, which has the preparation
patches [2] this series builds on.

As discussed, the goal is to get this applied to a for-7.x/drbd branch
so it can land in linux-next via block-next. After letting it mature
in linux-next for a while, it should go in via the block tree.

Thanks,
Christoph

[0] https://lore.kernel.org/linux-next/899e0337-9642-4ca6-9050-aeab14fa22ef@kernel.dk/
[1] https://github.com/LINBIT/drbd
[2] https://lore.kernel.org/linux-block/20260923140608.1116713-1-christoph.boehmwalder@linbit.com/

v2: https://lore.kernel.org/linux-block/20261006154607.3936501-1-christoph.boehmwalder@linbit.com/

Changes since v2:
- Rebased onto for-7.5/block, now that the preparation patches are
  applied there; v2 no longer applied
- Kept the in-tree DRBD changes that went into v7.4: the explicit
  linux/umh.h include and the conversion to sk_set_nospace()
- Synced with the current out-of-tree state


Christoph Böhmwalder (20):
  drbd: mark as BROKEN during DRBD 9 rework
  drbd: extend wire protocol definitions for DRBD 9
  drbd: introduce DRBD 9 on-disk metadata format
  drbd: add transport layer abstraction
  drbd: add TCP transport implementation
  drbd: add DAX/PMEM support for metadata access
  drbd: add optional compatibility layer for DRBD 8.4
  drbd: add application/resync IO synchronization documentation
  drbd: rework sender for DRBD 9 multi-peer
  drbd: replace per-device state model with multi-peer data structures
  drbd: rewrite state machine for DRBD 9 multi-peer clusters
  drbd: rework activity log and bitmap for multi-peer replication
  drbd: rework request processing for DRBD 9 multi-peer IO
  drbd: rework module core for DRBD 9 transport and multi-peer
  drbd: rework receiver for DRBD 9 transport and multi-peer protocol
  drbd: rework the netlink core for DRBD 9
  drbd: serve the "drbd" genl family at version 1 for existing userspace
  drbd: add the "drbd2" genl family
  drbd: update monitoring interfaces for multi-peer topology
  drbd: remove BROKEN for DRBD

 .../application-resync-synchronization.rst    |   208 +
 .../admin-guide/blockdev/drbd/index.rst       |     1 +
 Documentation/netlink/specs/drbd2.yaml        |  2600 +++
 drivers/block/drbd/Kconfig                    |    43 +
 drivers/block/drbd/Makefile                   |     9 +-
 drivers/block/drbd/drbd2_nl_gen.c             |   810 +
 drivers/block/drbd/drbd2_nl_gen.h             |   113 +
 drivers/block/drbd/drbd_actlog.c              |  1373 +-
 drivers/block/drbd/drbd_bitmap.c              |  2075 +-
 drivers/block/drbd/drbd_config.h              |    45 +-
 drivers/block/drbd/drbd_dax_pmem.c            |   175 +
 drivers/block/drbd/drbd_dax_pmem.h            |    43 +
 drivers/block/drbd/drbd_debugfs.c             |  1758 +-
 drivers/block/drbd/drbd_debugfs.h             |     2 +
 drivers/block/drbd/drbd_int.h                 |  3930 ++--
 drivers/block/drbd/drbd_interval.c            |    37 +-
 drivers/block/drbd/drbd_interval.h            |   130 +-
 drivers/block/drbd/drbd_legacy_84.c           |   641 +
 drivers/block/drbd/drbd_legacy_84.h           |   116 +
 drivers/block/drbd/drbd_main.c                |  6812 ++++--
 drivers/block/drbd/drbd_meta_data.h           |   170 +
 drivers/block/drbd/drbd_nl.c                  | 10232 ++++++---
 drivers/block/drbd/drbd_nl.h                  |   400 +
 drivers/block/drbd/drbd_nl_84.c               |  3622 ++++
 drivers/block/drbd/drbd_nl_defaults.c         |   168 +
 drivers/block/drbd/drbd_nl_drbd2.c            |  2589 +++
 drivers/block/drbd/drbd_nl_types.h            |   402 +
 drivers/block/drbd/drbd_polymorph_printk.h    |    37 +-
 drivers/block/drbd/drbd_proc.c                |   327 +-
 drivers/block/drbd/drbd_protocol.h            |   614 +-
 drivers/block/drbd/drbd_receiver.c            | 17304 ++++++++++++----
 drivers/block/drbd/drbd_req.c                 |  3188 ++-
 drivers/block/drbd/drbd_req.h                 |   332 +-
 drivers/block/drbd/drbd_sender.c              |  4445 ++--
 drivers/block/drbd/drbd_state.c               |  9203 ++++++--
 drivers/block/drbd/drbd_state.h               |   334 +-
 drivers/block/drbd/drbd_state_change.h        |    80 +-
 drivers/block/drbd/drbd_strings.c             |   103 +-
 drivers/block/drbd/drbd_strings.h             |     4 +-
 drivers/block/drbd/drbd_transport.c           |   545 +
 drivers/block/drbd/drbd_transport.h           |   487 +
 drivers/block/drbd/drbd_transport_tcp.c       |  1805 ++
 drivers/block/drbd/drbd_transport_template.c  |   164 +
 include/uapi/linux/drbd.h                     |   305 +-
 include/uapi/linux/drbd2.h                    |  1038 +
 include/uapi/linux/drbd_limits.h              |   138 +-
 46 files changed, 61765 insertions(+), 17192 deletions(-)
 create mode 100644 Documentation/admin-guide/blockdev/drbd/application-resync-synchronization.rst
 create mode 100644 Documentation/netlink/specs/drbd2.yaml
 create mode 100644 drivers/block/drbd/drbd2_nl_gen.c
 create mode 100644 drivers/block/drbd/drbd2_nl_gen.h
 create mode 100644 drivers/block/drbd/drbd_dax_pmem.c
 create mode 100644 drivers/block/drbd/drbd_dax_pmem.h
 create mode 100644 drivers/block/drbd/drbd_legacy_84.c
 create mode 100644 drivers/block/drbd/drbd_legacy_84.h
 create mode 100644 drivers/block/drbd/drbd_meta_data.h
 create mode 100644 drivers/block/drbd/drbd_nl.h
 create mode 100644 drivers/block/drbd/drbd_nl_84.c
 create mode 100644 drivers/block/drbd/drbd_nl_defaults.c
 create mode 100644 drivers/block/drbd/drbd_nl_drbd2.c
 create mode 100644 drivers/block/drbd/drbd_nl_types.h
 create mode 100644 drivers/block/drbd/drbd_transport.c
 create mode 100644 drivers/block/drbd/drbd_transport.h
 create mode 100644 drivers/block/drbd/drbd_transport_tcp.c
 create mode 100644 drivers/block/drbd/drbd_transport_template.c
 create mode 100644 include/uapi/linux/drbd2.h


base-commit: aa7014f8d7565cfea117eac36a5de0a05eba65a4
-- 
2.56.0

