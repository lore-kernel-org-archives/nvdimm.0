Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833350;
	b=1HumZ4mmlyTVJ72UTRBpBjK6PUpQFGMozzX6DQCaERpm/uee0SJ08BwLTyIhP/LQLA8w
	 MmmwAb9cvZaaXPC0/o0zaSAJMWJ7JuDNRqbhHL5IyUdM/7FrKB4W9X+P3LiDbWJq9PLZq
	 biWfCEfF6aYjgHVQmiQzdssR88vGtjzRefZVoQFBkzs3AjUZ2SlLK4oMk6fQIl++mddzp
	 f201AwTZZuVZaHrg8T6tGjqjYVph2iDnOaGoaeZcxV46YzQMoqVXQPzY9aO7biA48Zqni
	 nmF+r8wkS/4hie8NvBR1wzFSKHmzbL3ME4x6VizYRuEibl5klzeTkT7RVUbTBAArtjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+Msk6ANbZn/093DWI4JcEYr+FIuQ0NWktLmKrqtpKoY=;
	b=EposMkk2KnpCeof8CCYncTLTtJTa65p49WmD6x0N3K9ILkI5xB/lzoEm7zUEofKPqTQy
	 44im5izh6bcwcCQnHftvuyrhhCia89JAc02Cj6Ws8/VbkAI/GGOTHZE3tPztDX2xHw+g9
	 kRzlHLNx3w/LQUwY73Z87dV7cVZztHrmWtrgccKsaQxcUZjRwmEvqFTp3L2oeTQ9C++yU
	 yIfPIZ8OPNy5qKyJ5YxwMBA/9K7Wiv1kuY2i2AStKwpCFc8KOIUMIJoV+JK84VEPBSJaS
	 ySwvuDJf5YNXmm1YEEZy2B7nZmfVqxHctAI9YGwWoxFYc72L/h80vGNNzLXjKSx8mmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v4BBDbDa;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE02606A33D
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE02606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v4BBDbDa
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e977109392so7834985ad.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833349; x=1794438149; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Msk6ANbZn/093DWI4JcEYr+FIuQ0NWktLmKrqtpKoY=;
        b=v4BBDbDaWa3PWus7tTtwG0uWv9adM/4Qn2+lilLEqewfjlfnlzn4A8vXzbwH3NeLoV
         Saev2QMIJ93uppITgCoYmJGnLCkDIIT5OmILT1MPGfIsDCgO16yQ49gc6lgZsWsBctwA
         UGZZqnBycpWstdo9Y1UjNDf3OwyY1g8I8vlOdPVwN1J37RBjSi335ElE/vOIiwC/r8gJ
         5ao7qJMnlcZRonsD1E1Pnxot+D5JsJfX0YUC/SdBjBmOGFpqjSaXFJ9M/lrugGJCO8hW
         Y/EiNt5s/wv5WcJtIBf7x3rT1o9QaPfkLC0DjWvFoySpbz2JohvBSxSorQQfAsjZ5Vbv
         H8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833349; x=1794438149;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+Msk6ANbZn/093DWI4JcEYr+FIuQ0NWktLmKrqtpKoY=;
        b=aHHbHuy0QZ5H6A68HfZvioe4K3VMAtbrvewetwJci6XuHnhLqFwqjJnUgnAlmp4RXQ
         evscnfhDseGNMh72t/MwBQWMhz5S9KaOKo/p9wkHT1bgRlFosR9NBgycwzzOQuNoo/lc
         OYFZhCo3ICrt8jiuhPMLFe4ZCXOUYkNyOgEOZZEQaj7SjRffaKETAihhbzeWC1VVBmFF
         RcUf1R6AnkJoTKaG+L+Lbw5syVXVI/WmxleJZB0W7w4WqTl2Ej1jN5QBzHQQYNlXDxKP
         jFZf1VeAW3FowLuO4/U+26VjJrtxpAvr7YZyEZSyTNwoPtP4djVaxMlnWkAiYr/q72sq
         wZKA==
X-Gm-Message-State: APuU4Z90eP2nuFPr7rw6p6xL0CHgtuWMdsZiHoxVp24ZwNTV6kAEfu+5
	YR0PHSQIGeEUVOewuMtAxMuKiqryBpa67VtV1kK7WIeHH3JegQ8YwuYM
X-Gm-Gg: AYBFou3YYyFWYVhoHXIGwqiQCvg2YxP/mWUtbqG+13uzUsdumvLI87Bfr6uLD4tuDbX
	g4y0ozeUtf09CYe4RNBrMJyReTBk5jOVXoOXIEbDzlnFDUZWX4ZaV9Pd2dp/OcM0RH1to3tBRe4
	BkniN/4XjBCXfwXTZwcxLQylJKoK/6/uOC/Te9pfBrj1J19hGE/+T/F5nBeJfaM6YltgqLy8QB6
	Qr56zmmo/gqhhepcWmxpQEXHug7N8BoX7FYJ/3x9X6K1+rUVnQIGite6dEi1WNZeggJoAUUaY56
	Om0x/R76qCOQqjG0AHpbYmDHIFlX8WcQ9Qpwx6b/LICAcz7JbGIvfjT6/21Nkq17wwoc40KbCAf
	0iHIfvVEhArYc3puoRvdSqZv3h+e2wEnSgunaSowvIsEz41ouYMMKlEkllh3O7IfARmhoNZzx+Z
	OsCNGKmw44DjpFCa77kU1ZNc1Bop4v/zMKRXc0jw6kDNlpHKNhsFCV6uCtoB3EsYwKC1HMbu1lz
	aXpre4n1eSazyZYCKHcb1lNSfQRTOCeex24oXdsH0F9iuFEOedG6vqEt0u0g5yQbT9oO2cVKJi1
	BLfa+rYF01+OE4mk8Qa55lk6vNO7ew==
X-Received: by 2002:a17:903:1b2b:b0:2e5:54b9:6b5c with SMTP id d9443c01a7336-2eb36426f0fmr162418935ad.20.1793833348930;
        Wed, 04 Nov 2026 15:02:28 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:28 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 00/14] DCD CXL Series: Dynamic Capacity extent handling
Date: Thu,  5 Nov 2026 08:02:24 +0900
Message-ID: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
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

As discussed previously, the remaining DCD series will be split for
reviewability. I made the following split:

    DCD CXL Core half (current series) enables:
        - pointing an endpoint decoder at a DC partition
        - creating dax_cxl region for DCD (0-sized until resources added)
        - processing Add / Release Capacity events
        - sending DC Add/Release Response back to the device.

DCD stays disabled here too. The follow up:

  DCD DAX Series:
                - create dax_resources from accepted extents
                - build DAX devices from tag groups
                - prevent opening devdax w/write permission on read-only partition
                - expose tag_groups / extents in sysfs,
                - create_dynamic_ram*_region root decoder files for manual region creation
                - tools/testing/cxl additions for DCD
                - enable DCD

	^ NDCTL set goes with this one

Nothing in this series is reachable at runtime as posted: with
dcd_supported false no DC partition exists, the decoder mode store
refuses the dynamic_ram modes, no DC region can be created, and no
DCD event is ever read.  The intent is to get the extent handling
reviewed on its own while the DAX side follows.  Testing below is done
with the full series.

Patch Organization
==================
   1: (helper) region search returns the endpoint decoder for a DPA.
   2: Add dynamic_ram* endpoint decoder modes.
   3: Set up DC DAX region: 0-size seed device, with 0 HPA until extents
      are added as children
 4-5: Set up event handler pipeline with stubbed add/release logic
6-10: Add Capacity: Fill in add logic, introduce cxl_dc_tag_group /
      dc_extent objects, verify extent alignement, shared_extn_seq,
      check tag uniqueness, etc.
  11: Release Capacity: release tag groups as a whole, send Release
      DC response.
  12: Recover existing extents when a DC region's dax_region probes
  13: Rrace event for Dynamic Capacity event records.
  14: Documentation of the extent handling.

It will probably be useful to read over patch 14 (documentation) first
which explains how tags/shared extent sequence #s are handled.


[RFC] Sysfs interface
=====================
Since the sysfs interface spans both series, it's described here as
a whole so the decoder modes in patch 2 can be read in context. The
whole section is RFC, but especially endpoint decoder mode and the
root decoder create region files.

Memdev partition (exposed in follow up series):
        memX/ram/{size,qos_class}
        memX/pmem/{size,qos_class}
        memX/dynamic_ram_1/{size,qos_class,shareable,read_only}

Currently, only 1 DC partition is supported, but multiple would look
like this:
        memX/dynamic_ram_1/{size,qos_class,shareable,read_only}
        memX/dynamic_ram_2/{size,qos_class,shareable,read_only}
        ...
        memX/dynamic_ram_8/{size,qos_class,shareable,read_only}

dynamic_ram_X tells users which index they are looking at.

* Endpoint decoder mode (patch 2):
        decoderX.Y/mode/{dynamic ram |
                         dynamic_ram_shared |
                         dynamic_ram_ro |
                         dynamic_ram_shared_ro}

The code exists in the current series, but is not exposed because
dcd is turned off. It is necessary to keep in the current series
rather deferred for the follow up because extents need a parent
DAX_CXL region that is dc-capable, which requires an endpoint decoder with
dynamic_ram* mode

A decoder's DPA is allocated from a DC partition by writing one
of dynamic_ram, dynamic_ram_shared, dynamic_ram_ro or
dynamic_ram_shared_ro to decoderX.Y/mode. We only support 1 DC
partition today, so it must match the partition's read_only
and shareable attributes exactly. But for multiple, the intent
is to iterate over DC partitions and find the first one that
matches. If none match, it's refused with -ENXIO.

So users can specify "I want to use the shareable partition", or
"I want to use the read_only partition".

But if there were a device with multiple DC partitions that have
the same shareable/read-only attributes, the user will not be
able to select the specific partition.

So the other choice is to have dynamic_ram_{1-8} as the possible
modes (so in this series with only the first partition enabled,
the only choice would be dynamic_ram_1).

* Root decoder create files & region mode (in follow-up series):
        decoder0.0/create_dynamic_ram_region |
                   create_dynamic_ram_shared_region |
                   create_dynamic_ram_ro_region |
                   create_dynamic_ram_shared_ro_region

        regionX/mode/{dynamic ram |
                      dynamic_ram_shared |
                      dynamic_ram_ro |
                      dynamic_ram_shared_ro}

The decoder0.0/create_dynamic_ram_* fixes the region's mode at creation,
and every endpoint decoder attached must match the same mode.

The alternative is to have a single file:
        decoder0.0/create_dynamic_ram

which will create regionN with no mode. The mode is set when endpoint
decoderX.Y is written to target0 by inheriting the decoder's mode.

Tag Groups & Extents (in follow-up series)

  dax_regionX/tag_groupX.Y/{uuid,size}
                          /extentX.Y/{offset,length[,shared_extent_seq]}

  dax_regionX/untagged/{uuid (0000-000....)}/
                        extentX.Y/{offset,length}

Accepted capacity appears under the region's dax_regionX grouped by tag.
Under each tag_groupX.Y directory, is the group's UUID, combined size
of all extents in the group, and each extentX.Y in the group.
Each extentX.Y shows its offset, length, and if shared: shared_extn_seq.

Untagged extents appear under a general "untagged" directory, with
UUID = null uuid and *no size*, since each untagged extent is its
own logical allocation.

Git Info:
=========
Based on v7.4-rc1.

GitHub branches:
  this series:  https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-cxl-v1
  DAX series:   https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-dax-v1

NDCTL:
https://github.com/anisa-su993/anisa-ndctl/tree/dcd-v8

Testing
=======
Build: every patch of the series builds drivers/cxl and drivers/dax
with CONFIG_CXL_REGION=y and =n.

NDCTL cxl_test:
- no regressions
- cxl-dcd.sh also passing although ndctl set is not posted with this series and
the tools/testing changes for mock DC regions is in the follow-up series

Hardware: a DCD with one sharable, writable 128 GiB DC partition:
[   26.524021] cxl_core:cxl_get_dc_config:2377: cxl_pci 0000:0b:00.0: Read 1/1 DC partitions
[   26.524024] cxl_core:cxl_dc_check:2327: cxl_pci 0000:0b:00.0: DC partition 0 start 0x0 size 0x2000000000 blk_size: 0x10000000
[   26.524028] cxl_core:cxl_dev_dc_identify:2473: cxl_pci 0000:0b:00.0: Returning partition 0 0x0 size 0x2000000000
[   26.524031] cxl_core:cxl_configure_dcd:778: cxl_pci 0000:0b:00.0: Adding dynamic ram partition; 0x0 size 0x2000000000
[   26.524036] cxl_core:add_dpa_res:468: cxl_pci 0000:0b:00.0: DPA(dynamic_ram_1): [mem 0x00000000-0x1fffffffff flags 0x200]

Test the following driven by a fabric manager over MCTP from the platform BMC (Initiate
Dynamic Capacity Add and Release, prescriptive and tag-based):

- FMAPI Add (one More-chain): Tag_A{extent_1}, Tag_B{extent_2-4}
        - extents 2-4 with shared seq num 0, 1, 2

- Create DAX device from extent 1 and try mmap:
        anisa@cxlqual:~/ndctl$
        sudo python3 - <<'EOF'
        import mmap, os
        dev, size = "/dev/dax0.1", 0x80000000
        fd = os.open(dev, os.O_RDWR)
        m = mmap.mmap(fd, size)
        m[0:8] = b"DCDHEAD!"                # first page
        m[size - 8:size] = b"DCDTAIL!"      # last page
        m.close(); os.close(fd)
        fd = os.open(dev, os.O_RDONLY)
        m = mmap.mmap(fd, size, prot=mmap.PROT_READ)
        print(m[0:8], m[size - 8:size])
        m.close(); os.close(fd)
        EOF
        b'DCDHEAD!' b'DCDTAIL!'
        anisa@cxlqual:~/ndctl$

Try to add a tag that is already committed:
[ 1119.080597] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4801
[ 1119.080646] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6606.397305] cxl_core:cxl_mem_get_event_records:2053: cxl_pci 0000:0b:00.0: Reading event logs: 10
[ 6606.397322] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[ 6606.397359] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6606.397427] cxl_core:cxl_handle_dcd_event_records:1955: cxl_pci 0000:0b:00.0: DCD event add : DPA:0xb0000000 LEN:0x10000000
[ 6606.397439] cxl_pci 0000:0b:00.0: Tag 1b2c3d4e-5f60-4718-9a2b-3c4d5e6f7081: dropping group, tag already committed (firmware/orchestrator bug)
[ 6606.397451] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4802
[ 6606.397484] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6606.397491] cxl_core:cxl_clear_event_record:1092: cxl_pci 0000:0b:00.0: Event log '4': Clearing 27
[ 6606.397497] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0101
[ 6606.397536] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6606.397544] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[ 6606.397569] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms

Reject untagged extent on sharable partition:
[ 6820.356969] cxl_core:cxl_handle_dcd_event_records:1955: cxl_pci 0000:0b:00.0: DCD event add : DPA:0xc0000000 LEN:0x10000000
[ 6820.356981] cxl_core:cxl_validate_extent:341: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x00000000c0000000-0x00000000cfffffff] (DCR:[mem 0x00000000-0x1fffffffff])(00000000-0000-0000-0000-000000000000)
[ 6820.356993] cxl_pci 0000:0b:00.0: DC extent DPA [range 0x00000000c0000000-0x00000000cfffffff]: sharable-partition extent has null tag (firmware bug)
[ 6820.357003] cxl_core:cxl_realize_group:1612: cxl_pci 0000:0b:00.0: Tag 00000000-0000-0000-0000-000000000000: dropping group, failed to add extent DPA:0xc0000000 LEN:0x10000000
[ 6820.357013] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4802
[ 6820.357046] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6820.357053] cxl_core:cxl_clear_event_record:1092: cxl_pci 0000:0b:00.0: Event log '4': Clearing 28
[ 6820.357059] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0101
[ 6820.357099] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 6820.357105] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[ 6820.357130] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms

Unbind dax_cxl driver releases extents:
[ 6922.815346] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4803
[ 6922.815824] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 1ms
[ 6922.815830] cxl_core:unregister_tag_group:737:  extent0.2: DAX region rm extent HPA [range 0x0000000080000000-0x000000008fffffff]
[ 6922.815858] cxl_core:unregister_tag_group:737:  extent0.3: DAX region rm extent HPA [range 0x0000000090000000-0x000000009fffffff]
[ 6922.815866] cxl_core:unregister_tag_group:737:  extent0.4: DAX region rm extent HPA [range 0x00000000a0000000-0x00000000afffffff]
[ 6922.935361] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4803
[ 6922.935542] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 1ms
[ 6922.935547] cxl_core:unregister_tag_group:737:  extent0.1: DAX region rm extent HPA [range 0x0000000000000000-0x000000007fffffff]

Refuse add extents while dax_cxl not bound:
[ 7064.900283] cxl_core:cxl_handle_dcd_event_records:1955: cxl_pci 0000:0b:00.0: DCD event add : DPA:0xc0000000 LEN:0x10000000
[ 7064.900296] cxl_core:cxl_validate_extent:341: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x00000000c0000000-0x00000000cfffffff] (DCR:[mem 0x00000000-0x1fffffffff])(55555555-5555-5555-5555-555555555555)
[ 7064.900313] cxl_core:__cxl_dpa_to_region:3137: cxl decoder9.0: dpa:0xc0000000 mapped in region:region0
[ 7064.900320] cxl_pci 0000:0b:00.0: DC extent DPA [range 0x00000000c0000000-0x00000000cfffffff]: dax driver not ready, refusing
[ 7064.900327] cxl_core:cxl_realize_group:1612: cxl_pci 0000:0b:00.0: Tag 55555555-5555-5555-5555-555555555555: dropping group, failed to add extent DPA:0xc0000000 LEN:0x10000000
[ 7064.900337] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4802
[ 7064.900370] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[ 7064.900377] cxl_core:cxl_clear_event_record:1092: cxl_pci 0000:0b:00.0: Event log '4': Clearing 33
[ 7064.900384] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0101
[ 7064.900453] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 1ms
[ 7064.900461] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x0100
[ 7064.900486] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms

------ Reboot --------

Read previously accepted extents on reboot:
[   26.570494] cxl_pci:cxl_event_config:801: cxl_pci 0000:0b:00.0: Event config : BIOS DCD supported
[   26.872701] cxl_core:cxl_bus_probe:2412: cxl_pmu pmu_mem0.0: probe: 0
[   27.514742] cxl_pci:__cxl_pci_mbox_send_cmd:264: cxl_pci 0000:0b:00.0: Sending command: 0x4801
[   27.514797] cxl_pci:cxl_pci_mbox_wait_for_doorbell:75: cxl_pci 0000:0b:00.0: Doorbell wait took 0ms
[   27.514826] cxl_core:cxl_read_extent_list:2546: cxl_pci 0000:0b:00.0: Got extent list 0-3 of 4 generation Num:10
[   27.514829] cxl_core:cxl_read_extent_list:2570: cxl_pci 0000:0b:00.0: Processing extent 0/4 [range 0x0000000000000000-0x000000007fffffff] (e5407b12-9a68-4c31-8d5e-2f0916bd73a4) seq 0
[   27.514833] cxl_core:cxl_read_extent_list:2570: cxl_pci 0000:0b:00.0: Processing extent 1/4 [range 0x0000000080000000-0x000000008fffffff] (1b2c3d4e-5f60-4718-9a2b-3c4d5e6f7081) seq 0
[   27.514836] cxl_core:cxl_read_extent_list:2570: cxl_pci 0000:0b:00.0: Processing extent 2/4 [range 0x0000000090000000-0x000000009fffffff] (1b2c3d4e-5f60-4718-9a2b-3c4d5e6f7081) seq 0
[   27.514838] cxl_core:cxl_read_extent_list:2570: cxl_pci 0000:0b:00.0: Processing extent 3/4 [range 0x00000000a0000000-0x00000000afffffff] (1b2c3d4e-5f60-4718-9a2b-3c4d5e6f7081) seq 0
[   27.514843] cxl_core:cxl_validate_extent:341: cxl_pci 0000:0b:00.0: DC extent DPA [range 0x0000000000000000-0x000000007fffffff] (DCR:[mem 0x00000000-0x1fffffffff])(e5407b12-9a68-4c31-8d5e-2f0916bd73a4)
[   27.514849] cxl_core:__cxl_dpa_to_region:3137: cxl decoder9.0: dpa:0x0 mapped in region:region0
[   27.514852] cxl_core:cxl_add_extent:570: cxl decoder9.0: Add extent [range 0x0000000000000000-0x000000007fffffff] (e5407b12-9a68-4c31-8d5e-2f0916bd73a4)
[   27.514855] cxl_core:cxlr_add_extent:496: cxl_dax_region dax_region0: Alloc new tag group
[   27.514873] cxl_core:online_tag_group:842:  extent0.1: dc_extent HPA [range 0x0000000000000000-0x000000007fffffff] (e5407b12-9a68-4c31-8d5e-2f0916bd73a4)
[   27.514875] cxl_core:cxlr_notify_extent:470: cxl_dax_region dax_region0: Notify: type 0 tag e5407b12-9a68-4c31-8d5e-2f0916bd73a4


Anisa Su (5):
  cxl/port: Add dynamic capacity options to endpoint decoder mode
  cxl/mem: Add 20 second timeout for stalled DC event chains
  cxl/mem: Enforce tag-group semantics
  cxl/extent: Enforce cross-region tag uniqueness
  Documentation/cxl: Document DCD extent handling

Ira Weiny (9):
  cxl/core: Return endpoint decoder information from region search
  cxl/region: Add dynamic DAX region support
  cxl/mem: Introduce DC event handlers
  cxl/extent: Handle DC Add Capacity events
  cxl/mem: Drop misaligned DCD extent groups
  cxl/extent: Validate DC extent partition
  cxl/extent: Handle DC Release Capacity events
  cxl/region: Read existing extents on region creation
  cxl/mem: Trace Dynamic capacity Event Record

 Documentation/ABI/testing/sysfs-bus-cxl       |   30 +-
 .../driver-api/cxl/linux/cxl-driver.rst       |  181 +++
 Documentation/driver-api/cxl/maturity-map.rst |    2 +-
 drivers/cxl/core/Makefile                     |    2 +-
 drivers/cxl/core/core.h                       |  105 +-
 drivers/cxl/core/extent.c                     |  754 ++++++++++++
 drivers/cxl/core/hdm.c                        |   21 +-
 drivers/cxl/core/mbox.c                       | 1073 ++++++++++++++++-
 drivers/cxl/core/memdev.c                     |    4 +-
 drivers/cxl/core/port.c                       |   55 +-
 drivers/cxl/core/region.c                     |   74 +-
 drivers/cxl/core/region_dax.c                 |  131 +-
 drivers/cxl/core/trace.h                      |   79 +-
 drivers/cxl/cxl.h                             |  121 ++
 drivers/cxl/cxlmem.h                          |   84 ++
 drivers/cxl/pci.c                             |   20 +-
 drivers/dax/bus.c                             |   23 +
 drivers/dax/bus.h                             |    1 +
 drivers/dax/cxl.c                             |   40 +-
 include/cxl/event.h                           |   37 +
 tools/testing/cxl/Kbuild                      |    5 +-
 21 files changed, 2792 insertions(+), 50 deletions(-)
 create mode 100644 drivers/cxl/core/extent.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

