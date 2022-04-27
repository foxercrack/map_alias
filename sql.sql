--
-- Table structure for table `alias`
--

CREATE TABLE `alias` (
  `identifier` varchar(50) NOT NULL,
  `text` varchar(200) NOT NULL,
  `target` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for table `alias`
--
ALTER TABLE `alias`
  ADD PRIMARY KEY (`identifier`);
COMMIT;