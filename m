Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02231331A5B
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529413; cv=none; b=o6PxqjwiOdIc1EfbwedTqQPkB6/8Nexp5QB8QONyhiC9zD4zStVTu/6lSLJV128I6ynXHpWr91httceKR4ITVNm+ZublXMMiueO9ynT0CeDbOn6pPOO0Qn3zZXpILTgK961huXN03YMb2Kc5mxdyDTQXH3E8ou89wyqbFs/G2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529413; c=relaxed/simple;
	bh=kaqeLrLHZa9drafLnINjaxIEb3P6f8IphWQ68HOpHLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IEEPcqzEqESoPbCI+4/guL12xCGgfzB+XPFbVsirHQDzLLZPuzk1MHQa3e+SdblTqZVPijJCBqzHEZGP2vwC+xl16XkItrzRaHIWC2O0wDkFDbjHE7pXxzQCROCsLHhYnW69KF1S9ZCD/cBCeqZc8eYriEzJaztKlW6ud8ULrak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AiLddw6l; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiLddw6l"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-134ac81c445so10218297c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529410; x=1780134210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dABusEwKAfDVUmdiCpS1BgSuagroxOIxIpAv9nJZ5RQ=;
        b=AiLddw6lOA79jE2PmUMl5A+axAAKMiCPv23F5aWh3j7/U7cyBZI+iXBDexC+tf2E1+
         YEus6Y3cXgLezoJrGzyrWlRobGjhGn9V9hrF0sXRWCuwKuUi4XDBhuFOjkj86wj7vWkN
         D3QKYuH0ZoiXBqJCKa8WI3PByfrY6w0cph7ZrLh4guvfgcx1aHTFiWnknBBM6SzW9Eub
         ANQnXShhmUND+pY+yxpLJXeEEArTSVbYjkeaSgPQreCspWXpVmfO8lh1qZ83Nf83k6Ej
         bxQ87c+klFlsvYig/eyOh5QPdofYYPWw7oLqjyHWRE7YuIksVkNhzY8DWCwOZg6EHcxx
         NcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529410; x=1780134210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dABusEwKAfDVUmdiCpS1BgSuagroxOIxIpAv9nJZ5RQ=;
        b=lf89U2yZw7o1laUMtc3hG7Shoe6K6B6HhXhBg6cPBWeJqNqbbcWmlNV5drIM+3S0WN
         D+7uObud3JgLVb69JMxL3GzLNSaBxkUkY7J+9AQlTTwOoI8bTKkJG7tXSQH+HghgInyT
         hIqaO4NtJzwifW15LwZcdkvRj6VydGxaDUJSOz+F0bJHOzxpDnXsTpa+YmfuKpGcBi7s
         DsGATZnZ3FPmFQahMoQ66ovowqZ+0WhA123rTv/sNfCqYZNM944Fgwjy9128ycuehlPM
         HIkQS5oYMo8Rd3ATNYgwxVj4Wi2/2OQTj7rpV2UDihss0g/WpUb5aQcfBj+O/E+HsQjb
         U72g==
X-Gm-Message-State: AOJu0Yx44/9qKWaQPHSQ0JaBVjuleWREiIB46mXimZm34GqTxctIZz4c
	lNJv7F03/PBmFIe89ULhWKLL1t4C1eqNl0A+2vSP5zMD0kx6C7qK8jrm
X-Gm-Gg: Acq92OFZaFCNpGhLy6B27zd7hsNN6NSjsRjfsnIU9bt5ElhrpbL7bCPLtl6DtPYeiHO
	1DyCXmOKsNmlYdnXnZu6dWwlWbpGt/g3eXEymfGjQXfTYl6Zlh/wRVgoiQ18HVK5bdTXI8nLL9G
	6er9rlz/Zt2T1HjO1g+QJeQPal23FmNbKY5imX6o1jcoboY+BirFGpDTPdACOg3KdgjyBcEPYOD
	sTOJUUaMQj+pCySKfFF5DSB/l52bUtEFGH7A7LlyHzf6bN4jT1hymt9O+Ubxbsg8SBPF14IfZUH
	bp9LUO8jCjsk+SPpkkyQBHPMzqdVK5iGpQeA6UDZFu3e+h5pfNJ1Hnk9DEaPk/+ajsrX5xW91QW
	5sis99cGNRo3ZLxAge8lc6rJ/7byCQO2oEQFdeSAHkUFEw8oSBT6dHDrFius5Wo80I/5zLFJFnI
	djbTzUntLx6FV7xRO1jfnldOYlp348ZC7dT819fx1dey3LG3lfxYfdzz9HLtBZG6WzskY+maqYm
	YGMZeyRgG3P6QyoUw==
X-Received: by 2002:a05:7022:218:b0:134:fc89:3686 with SMTP id a92af1059eb24-1365fb4f86bmr2916466c88.24.1779529409745;
        Sat, 23 May 2026 02:43:29 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:29 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices (DCD)
Date: Sat, 23 May 2026 02:42:54 -0700
Message-ID: <cover.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Table of Contents
==================
- Use Case
- LSFMM`26 Discussion
- Updated Design Overview
    - DC Add
    - DC Release
- Series Info
- Changes from v9
    - CXL Layer Changes
    - DAX Layer Changes
- Testing
- References

Since this is v10, this cover letter is aimed at folks who are
familiar with the patchset history and concept of DCD. Background
section now lives at the bottom.

This series:
https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-v10-23-05-2026

The corresponding NDCTL branch:
https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-05-21

Use Case:
=========
The use case for DCD has been a long-time blocker for this series.
In the previous months, we discussed moving forward with FAMFS as
the first end-user for DCD.

In the CXL call from this week (19-05-2026), I mentioned another
potential use case: LM Cache (an open-source KV Cache layer for LLM
inference servers) supports using DAX-devices as a backend for L2
tier.

In the meeting, it was noted that "we don't actually need an in-kernel
user for DCD DAX devices because there's user space users of DCD DAX
devices and a DCD DAX device is just a DAX device."[meeting transcript] To
paraphrase, any consumer of DAX devices can use DCD, so I hope the
use case is not a blocker moving forward for the series, but
if there are outstanding concerns, let's discuss them now.

LSFMM`26 Discussion:
====================
To briefly recap, we discussed the following requirements:
1) tags must be unique

2) each tagged allocation (1+ extents with the same tag) forms one DAX device.
    a. if shared, the extents gets pieced together by the
       shared extent sequence number
    b. if not shared, extents get pieced together by the order
       they arrive in the event log
    c. extents are only surfaced to the DAX layer when the 'More' chain
       closes. The 'More' chain refers to DC event records grouped
       together with the 'More' bit. The end of the chain ('More'=0)
       means all extents for each tagged allocation have been sent.
    d. timeout if 'More' chain is not closed within 20s as a defensive
       measure against lost event records or crashed FM. Clears
       all extents that were pending add

3) untagged extents form their own DAX device -- 1 untagged extent : 1 DAX device

4) a DCD extent backed DAX device must present a contiguous range to the user
   irrespective of whether the extents are physically contiguous

5) interleaving between extents remains unsupported for now

Originally, tags were unsupported (all extents w/non-null tag was not accepted).
Shareable extents - a subset of tagged extents which have a shared_extn_seq number -
were also unsupported. We now support both.

For more details on the semantics of tagged allocations, shareability, and
the 'More' chain, see John Groves' RFC, which was refactored into this tree[1].

The section below describes the current design to satisfy these
requirements.

Updated Design Overview:
========================
This section describes the end-to-end flow for how extents from
the event log are accepted to how it surfaces as a DAX device.

    DC Add:
    ========
    The 2 main "phases" (illustrated in an example below) are:
    1) CXL layer validates and accepts device extents; notifies
       DAX layer
    - extents hang out under the DAX region as a sub-resource
     until claimed by a DAX device. The resource tree will sort
     by HPA range, but the step below will assemble them by
     tag and sequence order.

    2) "DC" DAX-devices must be created with a uuid specified:
    - similar to before, DC DAX devices must be created at size 0

    - in order to actually claim resources from the region,
     you must store tag_a to /sys/.../daxX.Y/uuid

    - this claims all sub-resources under DAX region with tag_a

    - each extent becomes the backing for dev_dax->ranges[i]
    - the index (i) depends on shared_ext_seq_num or
     arrival order for non-shared extents

    The diagram below illustrates an example and describes the key structures
    and which layer they live in.

    * To keep this diagram simple, DPA/HPA is left out. But to avoid confusion:
      e1, e2, and e3 are not necessarily contiguous, nor ordered by DPA/HPA.
      The sequence number is the sole determinant of how to piece them
      together for form the VA view.

          device extents   dc_extent           dax_resource       DAX device
          (CXL core)       (CXL DAX)           (DAX bus)        (/dev/daxN.Y)
          -------------    -------------       -------------      ------------
      shared extents
          e1 ─┐             ┌─► dc_e1 ─►       res_1 (seq=1) ──┐
          e2 ─┼── tag A ─► ┼─► dc_e2 ─►       res_2 (seq=2) ──┼─►  daxN.0
          e3 ─┘             └─► dc_e3 ─►       res_3 (seq=3) ──┘    (size = Σ |e_i|)
      
      tagged - unshared
          e4 ─┐             ┌─► dc_e4 ─►       res_4 (seq=1) ──┐
              ├── tag B ─► ┤                                    ├─►  daxN.1
          e5 ─┘             └─► dc_e5 ─►       res_5 (seq=2) ──┘    (size = Σ |e_i|)
      
      untagged
          e6 ─ null tag ─►    dc_e6 ─►         res_6 (seq=0) ────►  daxN.2
          e7 ─ null tag ─►    dc_e7 ─►         res_7 (seq=0) ────►  daxN.3

     - device extent:
          This is the exact payload structure of extents in
          a DC Add/Release event record.
          They get validated and processed in the CXL driver

     - dc_extent
          One per surviving device extent. Registered under
          the CXL DAX driver (parent = cxlr_dax->dev)

    /sys/bus/cxl/devices/dax_regionX/extentX.Y
    /sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
    /sys/bus/cxl/devices/dax_regionX/extentX.Y/length
    /sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid

     - dax_resource
          DAX bus's per-extent view, one-to-one with dc_extent.  Carries
          the tag uuid and a 1..n seq_num to the DAX layer so DAX devices can
          find the matched set and put into dev_dax->ranges[] in order.

     - DAX device (/dev/daxN.Y)
          Built when userspace writes the tag UUID to the seed device's
          'uuid' attribute.  
          uuid_claim_tagged() collects every matching dax_resource
          and assembles in seq_num order by appending each
          dax_resource to dev_dax->ranges[i] where i = seq_num.
          uuid_claim_untagged() grabs a single unused untagged dax_resource
          in its entirety.
          Resize (shrink and grow) is disallowed, since the size is
          pre-determined by sum of sizes of matching extents. Only resizing to 0
          is allowed for destroying the device.

    DC Release:
    ============
    Now that the coordination between CXL/CXL-DAX/DAX layers is understood, DC
    Release can be understood quickly with some pseudo-code.

    To summarize: release is done 'loosely', in the sense that we release
    the entire tag group upon receiving a release event containing any extent
    in the tag group rather than checking that every single extent in the
    tag group is in the release event. This only applies if the extent is
    not in use (corresponding dax_resource->use_count == 0).

    If the extent is in use, release can be delayed until it's not in use,
    since Force Release is unsupported.

        device                  cxl driver                cxl_dax driver
        -----                   --------------            --------------
        release(dpa, tag) ──► look up (dpa, tag) in
                                cxlr_dax->dc_extents
                               
       found → notify dax
                                  (DCD_RELEASE_CAPACITY) ─► backing in use?
                                                               EBUSY → defer
                                                               ok    → dax_region_rm_resources()
                                rm_tag_group():
                                  - invalidate memregion (once for group)
                                  - unregister every dc_extent device
                                  - cascades into dax_region_rm_resources()
                                     (refuse-all-or-none under
                                      dax_region_rwsem)

    The release path is always whole-tag-group; the kernel never splits
    a group in response to a sub-range release request.

Series Info
  =============
  The series builds on top of cxl-next with the famfs-v9 patchset
  applied.

  Specifically, famfs-v9 was applied on
  3939dba00f98 "Merge branch 'for-7.1/cxl-misc' into cxl-for-next",
  which then became the base for this series, so the history looks
  like this:

  |--branch tip - e3343e260ce4 Documentation/cxl: Document DCD...
  |... [DCD patches]
  |-- last famfs patch 878df599bd1f (famfs-v9) famfs_fuse: Add documentation
  |... [famfs patches]
  |-- base commit - 3939dba00f98 (origin/next)

  Since this series has gotten so long, I've broken the commits down
  into logical sections. Most of the original scaffolding commits are
  untouched (Sections 1-3).

   1. Device discovery and partition layout (4 commits)

    - 4700826deb08 cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
    - 692890d6934d cxl/mem: Read dynamic capacity configuration from the device
    - f7800561164a cxl/cdat: Gather DSMAS data for DCD partitions
    - 22ae445b8a99 cxl/core: Enforce partition order/simplify partition calls

    Identify a DCD, read its partition layout via the GET_DYNAMIC_CAPACITY_CONFIG
    mailbox, and pair each DC partition with its CDAT DSMAS entry
    (sharable / writable / coherency).

   2. Region and endpoint-decoder wiring (3 commits)

    - 45bc277b11c1 cxl/mem: Expose dynamic ram A partition in sysfs
    - 58e5e5007cd1 cxl/port: Add 'dynamic_ram_a' to endpoint decoder mode
    - 9f0e0b3deeb1 cxl/region: Add DC DAX region support

    Make DC partitions reachable through the existing region/decoder machinery
    so a DC region can be created with an HPA window that's empty until
    extents arrive.

   3. Event/interrupt plumbing (5 commits)

    - 2906584012fc cxl/events: Split event msgnum configuration from irq setup
    - a211cbf4417c cxl/pci: Factor out interrupt policy check
    - 7f2e4fe38541 cxl/mem: Configure dynamic capacity interrupts
    - aca91b273921 cxl/core: Return endpoint decoder information from region search
    - e11ff26899d6 cxl/mem: Set up framework for handling DC Events

    Configure the DCD interrupt class, refactor the irq policy plumbing, and add
    the event-loop framework that the ADD/RELEASE paths hang off of.

   4. DC Add Implementation (5 commits)

    - 68caa60e758c cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains
    - 22f480966589 cxl/extent: Handle DC Add Capacity events
    - 60e23199f7ef cxl/mem: Drop misaligned DCD extent groups
    - def526ee51b6 cxl/extent: Validate DC extent partition
    - 9e1f5b0b36fd cxl/mem: Enforce tag-group semantics

    Process device-offered extents after the "More"-chain closes, applying the
    per-extent checks (region resolution, endpoint decoder containment,
    no-overlap, duplicate tolerance) and per-tag-group checks (alignment,
    partition equality, seq-num integrity, all-or-nothing acceptance).
    A defensive watchdog refuses an unterminated ADD chain after 20s so a lost
    closing record can't strand the staged list.

   5. DC Release Implementation path (1 commit)

    - b6069cc18b77 cxl/extent: Handle DC Release Capacity events

    Handle device-initiated release: locate the owning tag group by (DPA, UUID)
    and release all extents in the group atomically.

   6. Cross-region uniqueness + sysfs surface (2 commits)

    - 8f4aa2f5da26 cxl/extent: Enforce cross-region tag uniqueness
    - 52f5a9ba1754 cxl/region/extent: Expose dc_extent information in sysfs

    Add the host-wide tag registry (cxl_tag_register) so an orchestrator UUID
    collision across regions is caught, and expose extent info as extentX.Y
    under its region device.

   7. CXL<->DAX bridge (2 commits)

    - 9195bbfbed68 cxl + dax: Surface dax_resources on DCD Add Capacity events
    - e6cea279dcb2 cxl + dax: Release dax_resources on DCD Release Capacity events

    Add the .notify callback on the cxl_dax region driver.
    On ADD: register one dax_resource per dc_extent.
    On RELEASE: atomically remove the whole tag set, with deferred release on
    -EBUSY.

   8. DAX bus DC support (4 commits)

    - 29393afa419c dax/bus: Factor out dev dax resize logic
    - 00e5da991afc dax/bus: Add uuid sysfs attribute to dax devices
    - 9c73377182f1 dax/bus: Reject resize on DC dax devices and enforce 0-size creation
    - 89784b600e42 dax/bus: Tag-aware uuid claim and show on DC dax devices

    Generalize the resize allocator to operate on any parent resource,
    add the new uuid attribute, gate DC sizing rules (reject any non-zero
    resize; size=0 is the destroy path), and implement the tagged/untagged
    claim flow.

   9. Boot-time scan (1 commit)

    - ec8d257b5305 cxl/region: Read existing extents on region creation

    Replay the device's already-accepted list at region probe so reboots and
    host crashes recover without losing tagged allocations.

   10. Tracing, mock, docs (4 commits)

    - 54f9e863fac7 cxl/mem: Trace Dynamic capacity Event Record
    - 41c47ec44202 tools/testing/cxl: Make event logs dynamic
    - b8aa5ccbb327 tools/testing/cxl: Add DC Regions to mock mem data
    - e3343e260ce4 Documentation/cxl: Document DCD extent handling and DC-backed DAX regions

    Add a tracepoint for DC event records, extend the cxl_test mocks to model
    dynamic event logs and DC partitions, and document the accept/release
    conditions plus how CXL and DAX coordinate add/release transactions

Changes from v9:
=================
I am comparing this patchset against the last "official" version
of this patchset by Ira [2]

This section describes the structural changes made to add support for
tags/sharing and uuid-based DAX device creation.

    ========= CXL Layer Changes ==============
    1) The original patchset was designed with interleaving in mind and
    without support for tags. As such, it was set up with
    struct region_extent forming the HPA range for 1+ interleaved
    cxled_extents.

    /**
     * struct cxled_extent - Extent within an endpoint decoder
     * @cxled: Reference to the endpoint decoder
     * @dpa_range: DPA range this extent covers within the decoder
     * @uuid: uuid from device for this extent
     */
    struct cxled_extent {
    struct cxl_endpoint_decoder *cxled;
    struct range dpa_range;
    uuid_t uuid;
    };
    struct region_extent {
        struct device dev;
        struct range hpa_range;
        uuid_t uuid;
        struct xarray decoder_extents;
    };

    > Without interleaving a device extent forms a 1:1 relationship with the
    > region extent [3]

    cxled_extent and region_extent are replaced by struct dc_extent and
    struct cxl_dc_tag_group to match the new requirement for tags and defers
    interleave support.

    struct dc_extent {
    struct device dev;
    struct cxl_dc_tag_group *group;
    struct cxl_endpoint_decoder *cxled;
    struct range dpa_range;
    struct range hpa_range;
    uuid_t uuid;
    u16 seq_num;
    };

    struct cxl_dc_tag_group {
    struct cxl_dax_region *cxlr_dax;
    uuid_t uuid;
    struct xarray dc_extents;
    unsigned int nr_extents;
    struct list_head registry_node;
    };


    2) More validation is done in mbox.c as well to support the
    tag-uniqueness, shared_extn_seq num integrity, etc. Most
    of this work is from John Groves[1].

    ========= DAX Layer Changes ==============
    As described above, struct dax_resource is a sub-resource
    of the dc dax region that represents a usable resource
    (physically backed).

    1)

    Original                          |  Now
    ----------------------------------|----------------------------------
    struct dax_resource {             |  struct dax_resource {
        struct dax_region *region;    |      struct dax_region *region;
        struct resource *res;         |      struct resource *res;
                                      |      uuid_t uuid;
                                      |      u16 seq_num;
        unsigned int use_cnt;         |      unsigned int use_cnt;
    };                                |  };

    The uuid and seq_num must be propagated to the DAX layer in
    order for DAX devices to be able to assemble them
    by tag and sequence number in dev_dax->ranges[].

    2) The model for claiming dax_resources has changed.


                |  Original                              |  Now
    ------------|----------------------------------------|----------------------------------------
    semantics   |  Tags were unsupported, so             |  dax_resources (which correspond to
                |  dax_resources were claimed through    |  1 extent) cannot be split up. Not
                |  the resize operation. Individual      |  only can extents not be partially
                |  extents could be partially claimed    |  claimed, but the entire tag group
                |  and unclaimed by DAX devices.         |  must be atomically claimed.
    ------------|----------------------------------------|----------------------------------------
    resize      |  Introduced the                        |  Removed dev_dax_resize_sparse().
                |  dev_dax_resize_sparse() function      |  Grow and shrink is disallowed
                |  to enable splitting extents.          |  because the size is predetermined
                |                                        |  by the tag group's size. Only
                |                                        |  resizing to size 0 for destroy
                |                                        |  is allowed.
    ------------|----------------------------------------|----------------------------------------
    uuid        |  — unsupported                         |  New dev_dax uuid sysfs attribute:
                |                                        |  /sys/bus/dax/devices/daxX.Y/+{uuid}+
                |                                        |  Enables uuid_store, which enables
                |                                        |  tag-aware resource claiming.


    3) Renamed 'sparse' DAX regions to 'DC' or 'DC-backed' DAX regions. Unsure if
    this is better?


Testing:
================
Unit testing:
  - The NDCTL branch posted at the top adds test/cxl-dcd.sh, which leverages
    the mock device and extent-injection helpers added in sec 10
    (41c47ec44202, b8aa5ccbb327).  Coverage:

    DC Add — validation
     - Misaligned (non-2M) extent drops the whole group
     - Overlapping extent injection rejected; original extent remains
     - "More"-chain: extents stay staged until More=0 closes the chain
     - Cross-More tag uniqueness: second event re-using a committed tag dropped
     - Sharable partition: shared extents arrive with device-stamped seq 1..n
     - Sharable group with a seq-integrity gap (1, 3) refused on claim

    DC Add — uuid claim
     - Pre-existing untagged + tagged extents (mock-injected at module load)
       claimed via --uuid "0" / tag uuid
     - Newly injected untagged + tagged extents claimed via --uuid "0" / tag
       uuid
     - Multiple extents under one tagged More-chain aggregate into a single
       DAX device of summed size
     - --uuid <unknown> fails with -ENOENT and does not consume region space
     - dev_dax uuid sysfs attribute reads back the claim source ("0" for
       untagged, the tag string for tagged)

    DC Release
     - Release event under an in-use DAX device is deferred (-EBUSY); the
       extent stays under the region until the DAX device is destroyed, then
       a re-issued release completes
     - Tag-group release: a release event addressed at any DPA in the group
       releases the whole group atomically
     - Partial-range release event targets the whole containing region_extent
       rather than carving it

    DAX device sizing policy
     - Plain create-device (no --uuid) on a sparse region fails
     - --uuid "0" with no remaining untagged dax_resource returns -ENOENT
     - Any non-zero resize on a sparse DAX device returns -EOPNOTSUPP
     - Resize on a tagged multi-extent DAX device also rejected
     - size=0 / destroy releases the dax_resource so it can be re-claimed

    Region / driver lifecycle
     - Destroy region with extents (no DAX devices) succeeds
     - Destroy region with extents + active DAX devices succeeds
     - Two DC regions hosted on the same DC partition
     - modprobe -r dax_cxl releases all extents; modprobe-in afterwards
       preserves region state and accepts new injections

QEMU testing:
Tested with Ali's QEMU patchset adding support for tags[4]

Topology: '-object memory-backend-file,id=cxl-mem1,mem-path=/tmp/t3_cxl1.raw,size=12G \
     -object memory-backend-file,id=cxl-lsa1,mem-path=/tmp/t3_lsa1.raw,size=1G \
     -device usb-ehci,id=ehci \
     -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1,hdm_for_passthrough=true \
     -device cxl-rp,port=0,bus=cxl.1,id=cxl_rp_port0,chassis=0,slot=2 \
     -device cxl-type3,bus=cxl_rp_port0,id=cxl-dcd0,dc-regions-total-size=12G,num-dc-regions=1,sn=99 \
     -device usb-cxl-mctp,bus=ehci.0,id=usb1,target=cxl-dcd0\
     -machine cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=12G,cxl-fmw.0.interleave-granularity=1k'

1. Start VM (12GB)
2. Issue QMP to add tagged backend (8GB):
{ "execute": "qmp_capabilities" }
{
    "execute": "object-add",
    "arguments": {
        "qom-type": "memory-backend-ram",
        "id": "tm0",
        "size": 8589934592,
        "share": true,
        "tag": "5be13bce-ae34-4a77-b6c3-16df975fcf1a"
    }
}
3. Create region on the VM: cxl create-region -m -d decoder0.0 -w 1 -s 8G mem0 -t dynamic_ram_a
4. Issue QMP to add an 8GB extent:
{ "execute": "qmp_capabilities" }
{
    "execute": "cxl-add-dynamic-capacity",
    "arguments": {
        "path": "/machine/peripheral/cxl-dcd0",
        "host-id": 0,
        "selection-policy": "prescriptive",
        "region": 0,
        "tag": "5be13bce-ae34-4a77-b6c3-16df975fcf1a",
        "extents": [
            {
                "offset": 0,
                "len": 8589934592
            }
        ]
    }
}
5. Verify with sysfs:
root@bgt-140510-bm03:~# cat /sys/bus/cxl/devices/dax_region0/extent0.0/offset
0x0
root@bgt-140510-bm03:~# cat /sys/bus/cxl/devices/dax_region0/extent0.0/length
0x200000000
root@bgt-140510-bm03:~# cat /sys/bus/cxl/devices/dax_region0/extent0.0/uuid
5be13bce-ae34-4a77-b6c3-16df975fcf1a

6. daxctl create-device -r region0 --uuid 5be13bce-ae34-4a77-b6c3-16df975fcf1a
[
  {
    "chardev":"dax0.1",
    "size":8589934592,
    "target_node":1,
    "align":2097152,
    "mode":"devdax"
  }
]
created 1 device

7. Test compatibility with famfs[5]

DEV=/dev/dax0.1 ./run_smoke.sh
... lots of other output ...

:== Test Timing Summary
:==-------------------------------------------------------------------
:==  prepare              0:13
:==  test_daxmode         0:06
:==  test_load_module     0:00
:==  test0                0:06
:==  test_shadow_yaml     0:05
:==  test1                0:17
:==  test2                0:11
:==  test3                0:03
:==  test4                0:16
:==  test_errors          0:01
:==  stripe_test          0:53
:==  test_pcq             1:31
:==  test_fio             0:34
:==-------------------------------------------------------------------
:==  TOTAL                4:40
:==-------------------------------------------------------------------
:==run_smoke completed successfully (Mon May 18 23:24:44 UTC 2026)

8. Test release
daxctl disable-device /dev/dax0.1
daxctl destroy-device /dev/dax0.1

Send release QMP
{ "execute": "qmp_capabilities" }
{
    "execute": "cxl-release-dynamic-capacity",
    "arguments": {
        "path": "/machine/peripheral/cxl-dcd0",
        "host-id": 0,
        "removal-policy": "prescriptive",
        "region": 0,
        "tag": "5be13bce-ae34-4a77-b6c3-16df975fcf1a",
        "extents": [
            {
                "offset": 0,
                "len": 8589934592
            }
        ]
    }
}

Extent sysfs entries disappear and dmesg shows:
[   55.816172] cxl_core:cxl_handle_dcd_event_records:1655: cxl_pci 0000:0d:00.0: DCD event release : DPA:0x0 LEN:0x200000000
[   55.819311] cxl_core:__cxl_dpa_to_region:3021: cxl decoder2.0: dpa:0x0 mapped in region:region0
[   55.821966] cxl_core:cxlr_notify_extent:368: cxl_dax_region dax_region0: Trying notify: type 1 tag 5be13bce-ae34-4a77-b6c3-16df975fcf1a
[   55.825736] cxl_core:cxlr_notify_extent:387: cxl_dax_region dax_region0: Notify: type 1 tag 5be13bce-ae34-4a77-b6c3-16df975fcf1a
[   55.829374] dax:__dax_release_resource:195: cxl_dax_region dax_region0: Extent release resource [mem 0x1290000000-0x148fffffff flags 0x80000200]
[   55.832745] cxl_core:dc_extent_unregister:489:  extent0.0: DAX region rm extent HPA [range 0x0000000000000000-0x00000001ffffffff]
[   55.836048] dax:__dax_release_resource:195: cxl_dax_region dax_region0: Extent release resource (null)
[   55.838850] cxl_core:cxled_release_extent:72: cxl decoder2.0: Remove extent [range 0x0000000000000000-0x00000001ffffffff] (5be13bce-ae34-4a77-b6c3-16df975fcf1a)
[   55.843347] cxl_core:memdev_release_extent:1197: cxl_pci 0000:0d:00.0: Release response dpa [range 0x0000000000000000-0x00000001ffffffff]
[   55.846887] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4803


Background
=============
A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
device that allows memory capacity within a region to change
dynamically without the need for resetting the device, reconfiguring
HDM decoders, or reconfiguring software DAX regions.

One of the biggest anticipated use cases for Dynamic Capacity is to
allow hosts to dynamically add or remove memory from a host within a
data center without physically changing the per-host attached memory nor
rebooting the host.

The general flow for the addition or removal of memory is to have an
orchestrator coordinate the use of the memory.  Generally there are 5
actors in such a system, the Orchestrator, Fabric Manager, the Logical
device, the Host Kernel, and a Host User.

An example work flow is shown below.

Orchestrator      FM         Device       Host Kernel    Host User

    |             |           |            |               |
    |-------------- Create region ------------------------>|
    |             |           |            |               |
    |             |           |            |<-- Create ----|
    |             |           |            |    Region     |
    |             |           |            |(dynamic_ram_a)|
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |             |           |            |               |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |-- Remove -->|- Release->|- Release ->|               |   |
    |  Capacity   |  Extent   |   Extent   |               |   |
    |             |           |            |               |   |
    |             |           |     (Release Ignored)      |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |             |- Release->|- Release ->|               |
    |             |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Destroy ----|
    |             |           |            |   Region      |
    |             |           |            |               |

References:
================

[1]: https://lore.kernel.org/linux-cxl/aesPAvUION9Zsadu@4470NRD-ASU.ssi.samsung.com/T/#m2a079aa47d5ec8cb1e6625d9b91c6aca09afbbd0
[2]: https://lore.kernel.org/linux-cxl/20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com/
[3]: https://lore.kernel.org/linux-cxl/20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com/T/#m97bb501f8cee434956f5cfbde3a65e9d7c0cd9be
[4]: https://lore.kernel.org/linux-cxl/20260325184259.366-1-alireza.sanaee@huawei.com/T/#t
[5]: https://github.com/cxl-micron-reskit/famfs

-- 
2.43.0

