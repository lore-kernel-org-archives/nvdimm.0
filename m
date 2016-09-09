From: Christoph Hellwig <hch@lst.de>
Subject: iomap based DAX path
Date: Fri,  9 Sep 2016 18:34:34 +0200
Message-ID: <1473438884-674-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

This series adds a DAX I/O path based on the iomap interface.  This
allows more efficient block mapping including defined hole semantics,
and is an important step toward getting rid of buffer_heads in XFS.

